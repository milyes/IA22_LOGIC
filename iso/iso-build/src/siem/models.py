
from dataclasses import dataclass, asdict
from datetime import datetime
from typing import List, Optional

@dataclass
class ZCoreEvent:
    timestamp: str
    tenant_id: str
    agent_id: str
    event_type: str  # tool_decision, dlp_detection, prompt_firewall, output_guard, incident
    tool: Optional[str] = None
    operation: Optional[str] = None
    decision: str = "ALLOW"  # ALLOW, REVIEW, BLOCK
    severity: str = "LOW"
    risk_score: int = 0
    incident_id: Optional[str] = None
    details: Optional[dict] = None

    def to_dict(self):
        return asdict(self)

    @staticmethod
    def now(**kwargs):
        kwargs.setdefault('timestamp', datetime.utcnow().isoformat()+'Z')
        return ZCoreEvent(**kwargs)
