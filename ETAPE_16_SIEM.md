
# ÉTAPE 16 — Multi-SIEM & Enterprise Integration - Version Complète

## 1. Objectif
Z-CORE ne remplace pas le SOC existant. Il s'y intègre.
Le but : chaque décision (ALLOW/REVIEW/BLOCK) est exportable vers l'infrastructure du client.

```
Z-CORE
  ├── Syslog RFC5424 (QRadar, Splunk, Graylog)
  ├── CEF (ArcSight, LogRhythm, Sentinel via CEF)
  ├── LEEF (QRadar natif)
  ├── Webhook JSON signé (Splunk HEC, Sentinel, Elastic)
  └── Ticketing (Jira, ServiceNow, TheHive)
       │
       ▼
     SIEM / SOAR / SOC
```

## 2. Schéma d'événement unifié
Tous les formateurs partent du même modèle : ZCoreEvent

## 3. Formats

### Syslog RFC5424
<PRI> + Structured Data [tenant, risk, decision]
Facilité local6 (22), severity mappée depuis LOW->CRITICAL

### CEF
CEF:0|NetSecurePro|Z-CORE|22.0.0|event_type:tool|Name|Severity|Extension
Utilise cs1=Tool, cs2=Operation, cn1=RiskScore, cs3=IncidentId

### LEEF 2.0
LEEF:2.0|NetSecurePro|Z-CORE|22.0.0|event_type|TAB delimited extension
Natif QRadar

### Webhook
JSON + HMAC-SHA256 signature (X-ZCore-Signature) + timestamp anti-replay

## 4. API d'intégration

def emit_event(event: ZCoreEvent):
    router = SIEMRouter(
        syslog=True,
        cef=True,
        leef=True,
        webhooks=[WebhookDispatcher(url="https://siem.company.com/hec", secret="...")]
    )
    return router.emit(event)

## 5. Exemple de sortie

Syslog:
<187>1 2026-05-13T12:30:00Z z-core-host Z-CORE - - [zcore@32473 tenant="company-a" agent="security-agent" risk="75" decision="BLOCK"] event=tool_decision tool=database_query op=DELETE severity=HIGH incident=INC-1042

CEF:
CEF:0|NetSecurePro|Z-CORE|22.0.0|tool_decision:database_query|BLOCK tool_decision|7|tenantId=company-a ...

LEEF:
LEEF:2.0|NetSecurePro|Z-CORE|22.0.0|tool_decision|\tdevTime=...\tsev=HIGH...

## 6. Ticketing
Jira / ServiceNow / TheHive payloads générés depuis Incident + Events corrélés

## 7. Résilience & Production
- Queue locale (disk) si SIEM indisponible
- Retry exponentiel
- Batching (max 100 events / 5s)
- TLS obligatoire, mTLS optionnel pour Enterprise
- Pas de secret dans les logs

## 8. Ce que cela apporte au SOC
- Corrélation directe avec logs existants
- Timeline lisible (12:20:41 Prompt -> 12:20:44 Incident)
- Action SOC : investigation, containment, audit trail complet
