#!/bin/bash
set -e
echo "=== IA22_LOGIC GitHub Pages Deploy ==="
echo "Version 22.0.0 - 2026-10-13T21:10:07.650838"
echo ""
echo "1. Vérification docs/"
ls -lh docs/
echo ""
echo "2. Git init si besoin"
if [ ! -d .git ]; then 
  git init 
  echo "Git init fait"
fi
echo ""
echo "3. Instructions de push:"
echo "git add ."
echo "git commit -m 'deploy IA22_LOGIC v22.0.0 Z-CORE ENTERPRISE - 2026-10-13'"
echo "git remote add origin https://github.com/milyes/IA22_LOGIC.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "4. Ensuite sur GitHub.com:"
echo "Settings -> Pages -> Build and deployment -> Source: Deploy from branch"
echo "Branch: main / Folder: /docs -> Save"
echo ""
echo "URL finale: https://milyes.github.io/IA22_LOGIC/"
echo ""
echo "Serveur local pour test:"
echo "python3 -m http.server 8000 --directory docs"
