# CHANGELOG - Z-CORE ENTERPRISE / IA22_LOGIC

All notable changes to this project will be documented in this file.

## [22.0.0] - 2026-10-13 - FINAL ENTERPRISE RELEASE
### Added - IA22_LOGIC Core
- `IA22_LOGIC:init` - config/default.json Zero-Trust defaults, risk thresholds LOW/MEDIUM/HIGH/CRITICAL
- `IA22_LOGIC:analyze` - Architecture optimisée: Policy Engine découplé, tenant isolation API/Storage/Logs/RAG
- `src/core.py` - RiskEngine stdlib only, DLP stub, Prompt Firewall patterns
- `src/z_core_gateway.py` - Z-CORE Gateway handler tenant_id + agent_id

### Added - Threat Detection & Incident Response (Étape 15)
- Incident Correlator: regroupement evt-1001..evt-1004 -> INC-1042
- Risk Engine: aggregation non-linéaire weighted, seuils 29/59/79/100
- Timeline SOC: 12:20:41 Prompt -> 12:20:44 Incident
- Workflow SOC: Detection -> Correlation -> Incident -> Analyste/Auto-policy -> Investigation/Containment -> Resolution -> Audit trail
- Isolation réversible avec approbation requise

### Added - Multi-SIEM & Enterprise Integration (Étape 16)
- `src/siem/models.py` - ZCoreEvent dataclass unifié
- `src/siem/syslog.py` - RFC5424, facility local6, Structured Data [zcore@32473]
- `src/siem/cef.py` - CEF:0|NetSecurePro|Z-CORE|22.0.0|sig|name|sev|ext cs1/cs2/cs3/cn1
- `src/siem/leef.py` - LEEF:2.0 natif QRadar
- `src/siem/webhook.py` - WebhookDispatcher HMAC-SHA256 + SIEMRouter multi-backend, queue disque, retry exponentiel, batch 100/5s
- `src/siem/ticketing.py` - Jira / ServiceNow / TheHive payloads depuis incidents corrélés
- Support QRadar, Splunk, ArcSight, LogRhythm, Sentinel, Elastic, Graylog

### Added - Hardening VM (Étape 17)
- `vm/hardening/hardening.sh` - UFW deny/allow 8443, SSH root no, sysctl CIS (ASLR, rp_filter, syncookies), AppArmor, /tmp noexec, auditd rules
- `vm/systemd/z-core.service` - NoNewPrivileges, PrivateTmp, ProtectSystem=strict, ProtectHome, ReadWritePaths
- `vm/hardening/Dockerfile.vm` - Ubuntu 24.04 + python venv + rsyslog + auditd
- `vm/iso-builder/build-iso.sh` - autoinstall user-data fr_FR + late-commands curtin in-target install.sh

### Added - Enterprise Deploy (Étape 18)
- `enterprise/deploy/docker-compose.enterprise.yml` - gateway + redis + postgres, read_only, no-new-privileges, volumes vault/logs
- `enterprise/deploy/kubernetes.yaml` - Namespace z-core, Deployment 3 replicas runAsNonRoot, liveness /healthz readiness /readyz, Service ClusterIP 8443
- `enterprise/deploy/enterprise.yaml` - Config DENY_BY_DEFAULT_FOR_TOOLS, DLP KMS, thresholds, SIEM formats, audit immutable 90d
- `enterprise/deploy/README_DEPLOY.md` - Checklist TLS/KMS/SIEM/Tenant/Audit/Backup/Runbook

### Added - Packaging
- `IA22_LOGIC:package` -> IA22_LOGIC_v22.0.0.zip (config/src/resources)
- `IA22_LOGIC:pdf` -> Fiche Officielle PDF
- `IA22_LOGIC:apk` -> WebView APK (assets/index.html + MainActivity.java)
- `IA22_LOGIC:iso` -> NetSecurePro_IA22_LOGIC.iso (tar avec config/src/autoinstall)
- `IA22_LOGIC:deploy` -> docs/index.html GitHub Pages + deploy_github_pages.sh + .nojekyll
- `Z-CORE_ENTERPRISE_DOSSIER_COMPLET_FINAL_v22.0.0.pdf` - Dossier complet 13 sections

### Added - Docs & GitHub
- `docs/index.html` - Site vitrine complet avec grid Syslog/CEF/LEEF/Webhook, timeline, tables hardening, deploy instructions
- `README.md` - Badges, architecture ASCII, commandes, étapes 15-18, validation table, artefacts, deploy steps
- `LICENSE` - Community/Enterprise/Managed terms
- `CHANGELOG.md` - Ce fichier

### Security Validation
- Runtime: Python 3.14.6 (prod target 3.12+)
- Stdlib deps: 0
- Injection Precision: 100.0%
- Injection Recall: 66.7% (axe amélioration principal)
- DLP Accuracy: 100.0%
- Latency p50 0.311ms p95 0.378ms p99 0.409ms
- Peak alloc 0.034 MB core

### Known Limitations
- Recall 66.7% -> amélioration Prompt Firewall prévue
- Mémoire 0.034 MB = allocation mesurée core, pas RSS totale process
- ISO nécessite xorriso pour build final + sha256sum
- APK WebView est wrapper, compilation finale nécessite Android SDK

### Roadmap
- Phase 1 Core: DONE
- Phase 2 Agent Security: DONE
- Phase 3 AI Supply Chain: DONE (Model Scanner stub)
- Phase 4 Enterprise: DONE (SIEM + Hardening + Deploy)
- Phase 5 NetSecurePro-Sec: Dataset cybersécurité -> QLoRA -> Eval indépendante -> Quant -> Z-PUCE (NEXT)

---

## [21.0.0] - 2025-12-01 - Beta
- Initial IA22_LOGIC beta

## [20.0.0] - 2025-09-01 - Prototype
- Prototype Z-CORE gateway

---
NetSecurePro IA © 2025 - Zoubirou Mohammed Ilyes | ORCID: 0009-0007-7571-3178
