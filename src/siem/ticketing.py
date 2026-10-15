
from .models import ZCoreEvent
import json

class TicketingIntegration:
    """
    Génère payload pour Jira, ServiceNow, TheHive
    """
    def to_jira(self, incident_id, events: list):
        return {
            "fields": {
                "project": {"key": "SEC"},
                "summary": f"[Z-CORE] Incident {incident_id} - {events[0].severity if events else 'HIGH'}",
                "description": f"Incident Z-CORE {incident_id}\nEvents: {json.dumps([e.to_dict() for e in events], indent=2)}",
                "issuetype": {"name": "Incident"},
                "priority": {"name": "High" if any(e.severity in ('HIGH','CRITICAL') for e in events) else "Medium"},
                "labels": ["z-core", "ai-security"]
            }
        }

    def to_servicenow(self, incident_id, events: list):
        return {
            "short_description": f"Z-CORE Incident {incident_id}",
            "urgency": "1" if any(e.severity=="CRITICAL" for e in events) else "2",
            "category": "Security",
            "subcategory": "AI Security",
            "correlation_id": incident_id,
            "work_notes": json.dumps([e.to_dict() for e in events])
        }

    def to_thehive(self, incident_id, events: list):
        return {
            "title": f"Z-CORE {incident_id}",
            "description": f"Correlated {len(events)} events",
            "severity": 3 if any(e.severity=="CRITICAL" for e in events) else 2,
            "tags": ["z-core", f"tenant:{events[0].tenant_id if events else 'unknown'}"],
            "source": "z-core"
        }
