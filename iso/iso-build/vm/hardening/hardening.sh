#!/bin/bash
set -e
echo "[*] NetSecurePro Hardening v22.0.0"
apt update && apt upgrade -y
useradd -m -s /bin/bash netsecure || true
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd || true
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 443/tcp
ufw allow 8443/tcp
ufw --force enable
cat > /etc/sysctl.d/99-zcore.conf <<'EOFCFG'
kernel.randomize_va_space=2
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.tcp_syncookies=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
kernel.sysrq=0
fs.suid_dumpable=0
EOFCFG
sysctl -p /etc/sysctl.d/99-zcore.conf
aa-enforce /etc/apparmor.d/* || true
mkdir -p /opt/netsecurepro/{IA22_LOGIC,vault,logs,audit}
mkdir -p /var/log/z-core
chmod 700 /opt/netsecurepro/vault
chmod 750 /opt/netsecurepro/IA22_LOGIC
chown -R netsecure:netsecure /opt/netsecurepro || true
python3 -m venv /opt/netsecurepro/venv --without-pip || true
cat > /etc/logrotate.d/z-core <<'EOLOG'
/var/log/z-core/*.json {
  daily
  rotate 90
  compress
  missingok
  create 0640 netsecure adm
}
EOLOG
mount -o remount,noexec,nosuid,nodev /tmp || true
echo "[+] Hardening termine"
