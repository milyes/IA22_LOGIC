#!/bin/bash
# IA22 CISO AUDIT V22.0.0-FINAL - D004+D003+D002+D005
DATE=$(date +%Y%m%d_%H%M%S)
AUDIT_DIR="audit_IA22_v${DATE}"
mkdir -p "$AUDIT_DIR"

# === D004 GATEKEEPER - ÉTHIQUE ===
echo -n "[D004] Code d'accès IA22: "
read -s INPUT_CLE
echo ""
if [ "$INPUT_CLE" != "1776" ]; then
  echo "[D004] ERREUR ETHIQUE - ACCES REFUSE"
  exit 1
fi
USER=$(whoami)
echo "[D004] ACCES AUTORISE - $USER"

# === D003 SOUVERAINETÉ ===
echo "[D003] VERIF ENVIRONNEMENT"
if [ -d "ia22_audit" ]; then
  echo "[IA22] D003 OK"
else
  echo "[IA22] D003 FAIL"
  exit 1
fi

# === D002 VÉRITÉ ===
echo "[D002] GENERATION RAPPORT"
echo "IA22 AUDIT $DATE" > "$AUDIT_DIR/RESUME_CISO.txt"
echo "USER: $USER" >> "$AUDIT_DIR/RESUME_CISO.txt"
echo "CLE: 1776" >> "$AUDIT_DIR/RESUME_CISO.txt"
echo "D003: OK" >> "$AUDIT_DIR/RESUME_CISO.txt"
HASH=$(sha256sum "$AUDIT_DIR/RESUME_CISO.txt" | awk '{print $1}')
echo "$HASH" > "$AUDIT_DIR/RESUME_CISO.txt.sig"

# === D005 TRACE ===
echo "$(date) [IA22] [D004] USER=$USER CLE=1776 HASH=$HASH" >> /sdcard/IA22/ethique.log
echo "$(date) [IA22] AUDIT TERMINE" >> /sdcard/IA22/journal.cef

echo "[IA22] AUDIT CREE DANS $AUDIT_DIR"
