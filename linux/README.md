# Linux tasks

Verified target: Ubuntu Desktop 22.04.5 LTS on VirtualBox, username `saif`, hostname `ps-VirtualBox`. The assignment's sample hostname, addresses, time, and resource numbers are illustrative and must not be hard-coded.

## System report

```bash
chmod +x system_report.sh
./system_report.sh
```

The script reads local OS/system information. Public IP detection needs working outbound internet and `curl`; without it the report says unavailable. It was run successfully after the VM reboot; output is saved in `../evidence/command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt`, with the public IP redacted in the repository copy. The script itself is read-only.

## Account and root password tasks (Ubuntu)

The account script was run. Verification confirmed `PS` has primary group `PSgroup` and secondary group `dba`. The root password was changed successfully and later checked: status `P` (password set), last changed November 14, 2026, no expiration. Do not rerun the script unless intentionally repeating account changes and the interactive password update. Evidence is in `../evidence/command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt`.

Ubuntu commonly locks direct root password login by default. The assignment does not specify whether root login should be enabled over SSH, so do not change SSH policy. Never put a password in a script, shell history, screenshot, or Git repository.

## MySQL, HAProxy, and firewall

The assignment does not specify package versions. The Ubuntu installer was run. Verification confirmed MySQL 8.0.46 and HAProxy 2.4.30 installed, enabled, and active; MySQL local ping returned `mysqld is alive`; `haproxy -c -f /etc/haproxy/haproxy.cfg` reported a valid configuration. UFW 0.36.1 is active and enabled at startup. Final policy/output is saved in `../evidence/command-outputs/01-linux/linux-verification-post-reboot-2026-11-15.txt`.

The PDF's exact requirement is: **“Allow TCP/UDP traffic only on port 3306 using firewall services and commands.”** UFW was initially inactive with no saved rules. The approved SSH-exception policy is now enabled, final rules were reviewed, and a new key-only SSH connection succeeded afterward.

The approved UFW policy allows the following. These commands were executed and verified:

```bash
sudo ufw show added
sudo ufw allow from 10.0.2.2 to any port 22 proto tcp
sudo ufw allow 3306/tcp
sudo ufw allow 3306/udp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw show added
sudo ufw enable
sudo ufw status numbered
sudo ufw status verbose
```

This assumes “allow traffic” means inbound access to services. It preserves SSH through the observed VirtualBox NAT source, but SSH is an explicit management exception and therefore does not literally allow only port 3306. The assignment does not specify inbound versus outbound scope or whether SSH may be exempted. If “only port 3306” is strict, configure and verify from the VirtualBox console with no SSH allow rule; SSH through host port 2222 will then be blocked. Do not remove the SSH exception or reset the firewall without a recovery plan. MySQL normally uses TCP; both TCP and UDP are included because the PDF explicitly requests both.

## Copy a file from Windows host to Ubuntu guest

### FTP, SFTP and SCP

FTP is the original File Transfer Protocol. Plain FTP does not encrypt credentials or file contents; FTPS adds TLS to FTP. SFTP is a separate file-transfer protocol carried inside an SSH connection and encrypts both authentication and data. SCP also transfers files over SSH and encrypts the connection. For this assignment, SCP was the demonstrated option; FTP/FTPS and SFTP are documented alternatives and were not tested.

On Ubuntu install/start OpenSSH server if it is not already available (`sudo apt install openssh-server`, `sudo systemctl enable --now ssh`). Determine the guest's reachable address and from Windows PowerShell, an SCP transfer can use:

```powershell
scp -P <SSH_PORT> .\file.txt <SSH_USER>@<VM_ADDRESS>:/home/<SSH_USER>/
```

The original Ubuntu desktop VM is `ProgressSoft-Desktop` (Ubuntu hostname `ps-VirtualBox`, SSH user `saif`), not the Tomcat Vagrant VM. The user reports a successful SCP transfer to that VM through Windows host port 2222, followed by matching SHA-256 hashes. The exact result and provenance are in [`scp-transfer-verification-2026-11-15.txt`](../evidence/command-outputs/01-linux/scp-transfer-verification-2026-11-15.txt). The earlier host-key warning is historical and superseded by this successful transfer. Because VM configurations have previously shown a shared host-port mapping, confirm that port 2222 currently targets `ProgressSoft-Desktop` before repeating the transfer.

The verified transfer copied `linux/system_report.sh` to `/tmp/progresssoft-scp-verification-system_report.sh`. To repeat from Windows PowerShell when the desktop VM owns host port 2222:

```powershell
scp -P 2222 .\linux\system_report.sh saif@127.0.0.1:/tmp/progresssoft-scp-verification-system_report.sh
Get-FileHash .\linux\system_report.sh -Algorithm SHA256
ssh -p 2222 saif@127.0.0.1 "sha256sum /tmp/progresssoft-scp-verification-system_report.sh"
```

For an interactive SFTP session from Windows PowerShell, connect and upload the same file with:

```powershell
sftp -P 2222 saif@127.0.0.1
put .\linux\system_report.sh /tmp/progresssoft-scp-verification-system_report.sh
exit
```

This example assumes host port 2222 currently forwards to `ProgressSoft-Desktop`; confirm the destination before connecting. SFTP was not tested for this assignment. WinSCP can also connect using SFTP. A literal FTP demonstration would require a separately configured FTP service and client; neither FTP nor FTPS was installed or tested.

## Optional evidence (screenshots are not required by the assignment)

If you choose to capture evidence, keep actual outputs and redact public IPs. Screenshots are optional. Useful proof includes:

1. The system report. Redact the public-IP value in the submission copy.
2. `id PS`, `getent group PSgroup`, `getent group dba`, and root password status/last-change metadata. Never show a password prompt or password value.
3. MySQL package/service, `mysqld is alive`, HAProxy package/service, and the successful HAProxy config check.
4. The SCP transfer and matching local/remote checksum.
5. The final active firewall status and numbered rules, labeling the TCP 22 SSH exception from `10.0.2.2`; do not claim strict port-3306-only compliance.

## Other inspection commands

```bash
cat /etc/os-release; uname -a
ip -brief address; hostnamectl
free -h; swapon --show; nproc
df -h; lsblk
systemctl --failed
```
