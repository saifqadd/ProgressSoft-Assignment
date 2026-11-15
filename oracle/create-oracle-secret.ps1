# Creates a local-only Oracle SYS/SYSTEM password file ignored by Git and
# mounted into the container as /run/secrets/oracle_pwd. Use -Generate for a
# cryptographically random password without interactive input.
param(
    [switch]$Generate,
    [string]$FileName = 'oracle_pwd.txt'
)
$ErrorActionPreference = 'Stop'
$secretDir = Join-Path $PSScriptRoot 'secrets'
if ([IO.Path]::GetFileName($FileName) -ne $FileName -or [string]::IsNullOrWhiteSpace($FileName)) {
    throw 'FileName must be a simple filename without a path.'
}
$secretPath = Join-Path $secretDir $FileName

New-Item -ItemType Directory -Path $secretDir -Force | Out-Null
if ($Generate) {
    $alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789'
    $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
    $bytes = New-Object byte[] 36
    try {
        $rng.GetBytes($bytes)
        $randomChars = New-Object char[] $bytes.Length
        for ($i = 0; $i -lt $bytes.Length; $i++) {
            $randomChars[$i] = $alphabet[[int]($bytes[$i] % $alphabet.Length)]
        }
        $password = 'Aa9' + (-join $randomChars)
        [IO.File]::WriteAllText($secretPath, $password, [Text.UTF8Encoding]::new($false))
    } finally {
        [Array]::Clear($bytes, 0, $bytes.Length)
        if ($randomChars) { [Array]::Clear($randomChars, 0, $randomChars.Length) }
        $password = $null
        $rng.Dispose()
    }
} else {
    $secure = Read-Host 'Enter a strong Oracle database password (input hidden)' -AsSecureString
    if ($secure.Length -lt 8) {
        throw 'Use at least 8 characters. Oracle password complexity checks may require mixed character classes.'
    }
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    try {
        $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [IO.File]::WriteAllText($secretPath, $plain, [Text.UTF8Encoding]::new($false))
    } finally {
        if ($bstr -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
        $plain = $null
        $secure.Dispose()
    }
}

# Restrict the generated file to the current Windows user and SYSTEM.
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
$userGrant = '{0}:(F)' -f $currentUser
& icacls.exe $secretPath /inheritance:r /grant:r $userGrant 'NT AUTHORITY\SYSTEM:(F)' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Could not restrict the secret file ACL with icacls.' }
$acl = Get-Acl -LiteralPath $secretPath
$unexpected = @($acl.Access | Where-Object { $_.IdentityReference.Value -notin @($currentUser, 'NT AUTHORITY\SYSTEM') -or $_.IsInherited })
if ($unexpected.Count -gt 0) { throw 'Oracle secret file ACL verification failed; do not use the file.' }
Write-Output "Oracle secret file created with restricted ACL: $secretPath"
