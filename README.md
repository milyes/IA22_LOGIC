# Z-CORE ENTERPRISE — AI Security Gateway & Zero-Trust Runtime Guard
### IA22_LOGIC v22.0.0 | NetSecurePro IA

[[Version](https://img.shields.io/badge/version-22.0.0-blue)](https://github.com/ilyyesl/IA22_LOGIC)
[[Python](https://img.shields.io/badge/python-3.12%2B-yellow)](https://python.org)
[[Zero-Trust](https://img.shields.io/badge/Zero--Trust-enabled-red)](https://github.com/ilyyesl/IA22_LOGIC)
[[SIEM](https://img.shields.io/badge/SIEM-Syslog%2FCEF%2FLEEF%2FWebhook-green)](https://github.com/ilyyesl/IA22_LOGIC)
[[License](https://img.shields.io/badge/license-Enterprise-lightgrey)](LICENSE)

**Auteur:** Zoubirou Mohammed Ilyes — ORCID: 0009-0007-7571-3178  
**Copyright:** NetSecurePro IA © 2025  
**Live Demo:** https://USERNAME.github.io/IA22_LOGIC/ *(remplace USERNAME)*

---

## 🚀 Live Demo GitHub Pages

> Site complet généré dans `/docs` — prêt pour GitHub Pages

[📄 Dossier Complet PDF](dist/Z-CORE_ENTERPRISE_DOSSIER_COMPLET_FINAL_v22.0.0.pdf) | [📦 ZIP](dist/IA22_LOGIC_v22.0.0.zip) | [📱 APK](dist/IA22_LOGIC.apk) | [💿 ISO](dist/NetSecurePro_IA22_LOGIC.iso)

---

## 1. Executive Summary

Z-CORE Enterprise est une passerelle de sécurité pour applications d'IA générative. Elle contrôle les flux entre utilisateurs, apps métier, agents autonomes et modèles locaux/distants.

**Approche Zero-Trust:**
- Entrées inspectées avant modèle
- DLP / Vault (PII, API keys, secrets)
- Agent Guard (tool calling policy)
- Sorties inspectées (AST)
- Journalisation corrélée + Risk Engine
- Modèles & RAG soumis à intégrité

Objectif: réduire et rendre mesurable la surface de risque avec contrôles déterministes.

---

## 2. Architecture

```
                         NETSECUREPRO
                              │
                       ┌──────▼──────┐
                       │   Z-CORE    │  IA22_LOGIC v22.0.0
                       └──────┬──────┘
                              │
       ┌──────────────────────┼──────────────────────┐
       ▼                      ▼                      ▼
   IDENTITY                 DLP               PROMPT FIREWALL
   RBAC/ABAC               VAULT                   │
        │                     │                    │
        └─────────────────────┼────────────────────┘
                              ▼
                       POLICY ENGINE
                              │
                       AGENT GUARD
                              │
                       SECURE RAG
                              │
                      MODEL SCANNER
                              │
                       LOCAL / CLOUD LLM
                              │
                       OUTPUT GUARD
                              │
                    RUNTIME DETECTION
                              │
                         RISK ENGINE
                              │
                    INCIDENT CORRELATOR
                              │
                 ┌────────────┴────────────┐
                 ▼                         ▼
              SOC / UI                   SIEM
        Syslog / CEF / LEEF / Webhook / Jira / ServiceNow
```

---

## 3. IA22_LOGIC — Commandes

```bash
IA22_LOGIC:init      # Initialise config/default.json
IA22_LOGIC:analyze   # Analyse + architecture optimisée
IA22_LOGIC:package   # ZIP
IA22_LOGIC:pdf       # Fiche officielle
IA22_LOGIC:apk       # APK WebView
IA22_LOGIC:iso       # ISO VM NetSecurePro
IA22_LOGIC:deploy    # GitHub Pages + local server
```

```python
from src.core import IA22LogicEngine
engine = IA22LogicEngine()
result = engine.process("Test prompt suspect")
# -> {dlp, prompt_firewall, risk, decision: ALLOW/REVIEW/BLOCK}
```

---

## 4. Threat Detection & Incident Response — Étape 15

```
Prompt suspect (evt-1001)
  → Accès document sensible (evt-1002)
  → Tool call inhabituel (evt-1003)
  → Tentative exfiltration (evt-1004)
  → INCIDENT CORRELATOR → INC-1042
```

**Timeline SOC:**
```
12:20:41 Prompt reçu
12:20:42 PII détectée
12:20:42 Requête caviardée
12:20:43 Tool call demandé
12:20:43 Policy → REVIEW
12:20:44 Action bloquée
12:20:44 Incident créé
```

**Risk Engine:**
```
0–29 LOW → log
30–59 MEDIUM → surveillance
60–79 HIGH → blocage + alerte
80–100 CRITICAL → blocage + isolation réversible + incident
```

---

## 5. Multi-SIEM — Étape 16

**Modèle unifié:** `ZCoreEvent` → formateurs:

- **Syslog RFC5424** (QRadar/Splunk/Graylog): `<PRI> + [tenant@32473 tenant="company-a" risk="75"]`
- **CEF** (ArcSight/LogRhythm/Sentinel): `CEF:0|NetSecurePro|Z-CORE|...|cs1=Tool cn1=Risk`
- **LEEF 2.0** (QRadar natif): `LEEF:2.0|NetSecurePro|Z-CORE|...`
- **Webhook JSON signé HMAC-SHA256:** `X-ZCore-Signature` + anti-replay

```python
from src.siem.webhook import SIEMRouter, WebhookDispatcher
router = SIEMRouter(syslog=True, cef=True, leef=True, webhooks=[WebhookDispatcher("https://siem.company.local/hec")])
router.emit(event)
```

Ticketing: Jira / ServiceNow / TheHive payloads.

---

## 6. Hardening VM — Étape 17

`vm/hardening/hardening.sh`:
- UFW deny incoming, allow 8443
- SSH root no, key only
- sysctl CIS: ASLR, rp_filter, syncookies
- AppArmor enforce, /tmp noexec
- auditd + systemd hardening: NoNewPrivileges, PrivateTmp, ProtectSystem=strict

**Service:** `vm/systemd/z-core.service`

---

## 7. ISO & Enterprise Deploy — Étape 18

**ISO Builder:**
```bash
# autoinstall user-data + late-commands -> /opt/netsecurepro/IA22_LOGIC
xorriso -as mkisofs -r -V "NetSecurePro Z-CORE 22.0.0" -o NetSecurePro-ZCORE-22.0.0.iso /tmp/iso-build
```

**Docker Compose:**
```bash
docker-compose -f enterprise/deploy/docker-compose.enterprise.yml up -d
```

**Kubernetes (3 replicas, non-root):**
```bash
kubectl apply -f enterprise/deploy/kubernetes.yaml
```

**Config:** `enterprise/deploy/enterprise.yaml`

---

## 8. Validation

| Métrique | Valeur |
|----------|--------|
| Runtime | Python 3.14.6 / target 3.12+ |
| Stdlib deps | 0 |
| Injection Precision | 100.0% |
| Injection Recall | 66.7% (axe amélioration) |
| DLP Accuracy | 100.0% |
| p50 / p95 / p99 | 0.311 / 0.378 / 0.409 ms |
| Peak alloc | 0.034 MB core |

---

## 9. Modèle Commercial

- **Community:** local, DLP, Prompt Firewall, code inspection
- **Enterprise:** on-premise, Agent Guard, Secure RAG, Model Scanner, SIEM, RBAC/ABAC, audit, support pro
- **Managed:** API Gateway managée, multi-tenant, SLA

---

## 10. Roadmap

- **Phase 1 Core:** Gateway, DLP, Prompt Firewall, Policy, Audit
- **Phase 2 Agent:** Agent Guard, Tool Policy, Runtime Detection, Risk Engine
- **Phase 3 Supply Chain:** Model Scanner, Registry, Secure RAG
- **Phase 4 Enterprise:** Identity, Multi-tenancy, Vault/KMS, SIEM, Incident Response
- **Phase 5 NetSecurePro-Sec:** Dataset cybersécurité → QLoRA → Eval → Quant → Z-PUCE

**Positionnement:**
- NetSecurePro = AI Security Platform
- Z-CORE = AI Security Gateway
- Z-PUCE = AI/Agent Runtime Control Plane
- NetSecurePro-Sec = modèle cybersécurité spécialisé

---

## 📁 Artefacts

```
dist/
├── IA22_LOGIC_v22.0.0.zip
├── IA22_LOGIC_Fiche_Officielle.pdf
├── Z-CORE_ENTERPRISE_DOSSIER_COMPLET_FINAL_v22.0.0.pdf
├── IA22_LOGIC.apk
├── NetSecurePro_IA22_LOGIC.iso
├── IA22_LOGIC_ETAPE16_SIEM.zip
└── IA22_LOGIC_ETAPE17_18_ENTERPRISE.zip

src/
├── core.py
├── z_core_gateway.py
└── siem/
    ├── models.py
    ├── syslog.py
    ├── cef.py
    ├── leef.py
    ├── webhook.py
    └── ticketing.py

vm/
├── hardening/hardening.sh
├── systemd/z-core.service
└── iso-builder/build-iso.sh

enterprise/deploy/
├── docker-compose.enterprise.yml
├── kubernetes.yaml
└── enterprise.yaml

docs/
├── index.html (GitHub Pages)
└── .nojekyll
```

---

## 🚀 Déploiement GitHub Pages

```bash
git add .
git commit -m "deploy IA22_LOGIC v22.0.0 Z-CORE ENTERPRISE"
git remote add origin https://github.com/USERNAME/IA22_LOGIC.git
git branch -M main
git push -u origin main
# GitHub Settings -> Pages -> Source: /docs on branch main
```

---

**NetSecurePro IA © 2025 — Zoubirou Mohammed Ilyes | ORCID: 0009-0007-7571-3178**
