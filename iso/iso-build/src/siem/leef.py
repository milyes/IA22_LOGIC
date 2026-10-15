
from .models import ZCoreEvent
from datetime import datetime

class LEEFFormatter:
    """
    LEEF:2.0|Vendor|Product|Version|EventID|Delimiter|Extension
    """
    def format(self, event: ZCoreEvent) -> str:
        vendor = "NetSecurePro"
        product = "Z-CORE"
        version = "22.0.0"
        event_id = f"{event.event_type}"
        # LEEF header uses TAB as delimiter, we use \t
        ts = event.timestamp
        ext = f"\tdevTime={ts}\tsev={event.severity}\tusrName={event.tenant_id}\tcat={event.event_type}\tact={event.decision}\trisk={event.risk_score}\ttool={event.tool}\top={event.operation}\tincidentId={event.incident_id}"
        return f"LEEF:2.0|{vendor}|{product}|{version}|{event_id}|{ext}"
