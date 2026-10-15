
import socket
from .models import ZCoreEvent

class SyslogFormatter:
    """
    RFC5424 Syslog
    <PRI>VERSION TIMESTAMP HOSTNAME APP-NAME PROCID MSGID STRUCTURED-DATA MSG
    """
    FACILITY = 22  # local6
    SEVERITY_MAP = {"LOW": 5, "MEDIUM": 4, "HIGH": 3, "CRITICAL": 2}

    def format(self, event: ZCoreEvent) -> str:
        sev = self.SEVERITY_MAP.get(event.severity, 5)
        pri = self.FACILITY * 8 + sev
        # <14>1 2026-05-13T12:30:00Z z-core-host Z-CORE - - [tenant@32473 tenant="company-a" risk="75"] Tool decision BLOCK
        sd = f'[zcore@32473 tenant="{event.tenant_id}" agent="{event.agent_id}" risk="{event.risk_score}" decision="{event.decision}"]'
        msg = f"event={event.event_type} tool={event.tool} op={event.operation} severity={event.severity} incident={event.incident_id}"
        return f"<{pri}>1 {event.timestamp} z-core-host Z-CORE - - {sd} {msg}"

    def send_udp(self, formatted: str, host="127.0.0.1", port=514):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.sendto(formatted.encode(), (host, port))
