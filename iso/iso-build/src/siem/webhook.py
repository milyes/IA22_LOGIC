
import json, hmac, hashlib, time, urllib.request
from .models import ZCoreEvent
from typing import List

class WebhookDispatcher:
    def __init__(self, url: str, secret: str = None, timeout=5):
        self.url = url
        self.secret = secret
        self.timeout = timeout

    def build_payload(self, event: ZCoreEvent) -> dict:
        return {
            "version": "1.0",
            "source": "z-core",
            "timestamp": event.timestamp,
            "tenant_id": event.tenant_id,
            "event": event.to_dict()
        }

    def sign(self, payload: bytes) -> str:
        if not self.secret:
            return ""
        return hmac.new(self.secret.encode(), payload, hashlib.sha256).hexdigest()

    def send(self, event: ZCoreEvent):
        payload = json.dumps(self.build_payload(event)).encode()
        req = urllib.request.Request(self.url, data=payload, headers={
            "Content-Type": "application/json",
            "X-ZCore-Signature": self.sign(payload),
            "X-ZCore-Timestamp": str(int(time.time()))
        }, method="POST")
        # In prod, use requests with retry
        try:
            with urllib.request.urlopen(req, timeout=self.timeout) as resp:
                return resp.status
        except Exception as e:
            return f"FAILED: {e}"

class SIEMRouter:
    """Route un event vers plusieurs sorties"""
    def __init__(self, syslog=None, cef=None, leef=None, webhooks: List[WebhookDispatcher]=None):
        self.syslog = syslog
        self.cef = cef
        self.leef = leef
        self.webhooks = webhooks or []
        self.backends = []

    def emit(self, event: ZCoreEvent):
        outputs = {}
        if self.syslog:
            from .syslog import SyslogFormatter
            outputs['syslog'] = SyslogFormatter().format(event)
        if self.cef:
            from .cef import CEFFormatter
            outputs['cef'] = CEFFormatter().format(event)
        if self.leef:
            from .leef import LEEFFormatter
            outputs['leef'] = LEEFFormatter().format(event)
        # Dispatch webhooks async en prod
        for wh in self.webhooks:
            wh.send(event)
        return outputs
