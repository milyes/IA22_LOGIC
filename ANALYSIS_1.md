
# IA22_LOGIC - Analyse d'Architecture Optimisée

## Structures de données actuelles
- config/default.json: configuration centralisée
- src/core.py: moteur logique
- resources/: assets

## Architecture Proposée Optimisée (Z-CORE compliant)

```
IA22_LOGIC/
├── config/
│   ├── default.json
│   ├── policies/
│   │   ├── dlp_policies.yaml
│   │   ├── prompt_policies.yaml
│   │   └── tool_policies.yaml
│   └── tenants/
├── src/
│   ├── core.py (RiskEngine)
│   ├── dlp/
│   │   ├── scanner.py
│   │   └── vault.py
│   ├── firewall/
│   │   ├── prompt_firewall.py
│   │   └── output_guard.py
│   ├── agent/
│   │   ├── agent_guard.py
│   │   └── tool_policy.py
│   ├── rag/
│   │   └── secure_rag.py
│   ├── model/
│   │   └── scanner.py
│   └── siem/
│       ├── syslog.py
│       ├── cef.py
│       ├── leef.py
│       └── webhook.py
├── resources/
├── dist/
├── docs/
└── tests/
```

## Optimisations recommandées
1. Zero dépendances externes pour core (stdlib only)
2. Policy Engine découplé
3. Tenant isolation au niveau API + Storage + Logs
4. Risk aggregation non-linéaire avec calibration
5. Incident Correlator asynchrone
6. Audit immuable

## Matrice de performance cible
p50 < 1ms, p95 < 2ms, peak alloc < 5MB
