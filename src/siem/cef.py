
from .models import ZCoreEvent
import re

class CEFFormatter:
    """
    CEF:0|Device Vendor|Device Product|Device Version|Signature ID|Name|Severity|Extension
    """
    def format(self, event: ZCoreEvent) -> str:
        # Escape pipe and =
        def esc(s): return re.sub(r'([|=\\])', r'\\\1', str(s)) if s else "-"
        vendor = "NetSecurePro"
        product = "Z-CORE"
        version = "22.0.0"
        sig_id = f"{event.event_type}:{event.tool or 'na'}"
        name = f"{event.decision} {event.event_type}"
        sev_map = {"LOW":1, "MEDIUM":4, "HIGH":7, "CRITICAL":10}
        severity = sev_map.get(event.severity, 1)
        ext = f"tenantId={esc(event.tenant_id)} agentId={esc(event.agent_id)} act={esc(event.decision)} cs1={esc(event.tool)} cs1Label=Tool cs2={esc(event.operation)} cs2Label=Operation cn1={event.risk_score} cn1Label=RiskScore cs3={esc(event.incident_id)} cs3Label=IncidentId msg={esc(event.details)}"
        return f"CEF:0|{vendor}|{product}|{version}|{esc(sig_id)}|{esc(name)}|{severity}|{ext}"
