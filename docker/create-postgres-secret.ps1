# Generates a random local PostgreSQL password without displaying it.
# The output path is Git-ignored. Do not copy the generated secret into logs.
$ErrorActionPreference = 'Stop'
$secretDir = Join-Path $PSScriptRoot 'secrets'
$secretPath = Join-Path $secretDir 'postgres_password.txt'
New-Item -ItemType Directory -Path $secretDir -Force | Out-Null

$alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789'
$rng = [Security.Cryptography.RandomNumberGenerator]::Create()
$bytes = New-Object byte[] 40
try {
    $rng.GetBytes($bytes)
    $chars = foreach ($byte in $bytes) { $alphabet[[int]($byte % $alphabet.Length)] }
    $password = -join $chars
    [IO.File]::WriteAllText($secretPath, $password, [Text.UTF8Encoding]::new($false))
} finally {
    [Array]::Clear($bytes, 0, $bytes.Length)
    $password = $null
    $rng.Dispose()
}

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
$userGrant = '{0}:(F)' -f $currentUser
& icacls.exe $secretPath /inheritance:r /grant:r $userGrant 'NT AUTHORITY\SYSTEM:(F)' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Could not restrict the secret file ACL with icacls.' }
$acl = Get-Acl -LiteralPath $secretPath
$unexpected = @($acl.Access | Where-Object { $_.IdentityReference.Value -notin @($currentUser, 'NT AUTHORITY\SYSTEM') -or $_.IsInherited })
if ($unexpected.Count -gt 0) { throw 'Secret file ACL verification failed; do not use the file.' }
Write-Output "Created a random PostgreSQL secret with restricted ACL: $secretPath"
