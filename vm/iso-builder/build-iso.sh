#!/bin/bash
VERSION="22.0.0"
echo "[*] Build ISO NetSecurePro-ZCORE-${VERSION}"
mkdir -p /tmp/iso-build/scripts
cat > /tmp/iso-build/scripts/install.sh <<'SCRIPT'
mkdir -p /opt/netsecurepro/IA22_LOGIC
cp -r /cdrom/IA22_LOGIC/* /opt/netsecurepro/IA22_LOGIC/
bash /opt/netsecurepro/IA22_LOGIC/vm/hardening/hardening.sh
systemctl enable z-core.service
SCRIPT
chmod +x /tmp/iso-build/scripts/install.sh
cp -r /mnt/data/IA22_LOGIC /tmp/iso-build/IA22_LOGIC
echo "Ready for xorriso -as mkisofs -o NetSecurePro-ZCORE-22.0.0.iso /tmp/iso-build"
