#!/bin/bash
CHAIN=~/.orbit-scribe/chain.jsonl
mkdir -p ~/.orbit-scribe

case $1 in
  seal)
    ~/IA22_LOGIC/ia22_orbit.sh "$2" | grep '{' | tail -n 1 | tee -a "$CHAIN" | jq -r .seal
    ;;
  verify) tail -n 1 "$CHAIN" | jq . ;;
  last) tail -n 1 "$CHAIN" ;;
  export) cp "$CHAIN" ~/.sahbi0/seals/export-$(date +%F).jsonl && echo "Exporté" ;;
  *) echo "Usage: bin seal \"D...\" | bin verify | bin last | bin export" ;;
esac
