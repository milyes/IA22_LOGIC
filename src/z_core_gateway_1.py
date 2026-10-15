
from core import IA22LogicEngine
class ZCoreGateway:
    def __init__(self):
        self.engine = IA22LogicEngine()
    def handle(self, tenant_id, agent_id, prompt):
        event = self.engine.process(prompt)
        return {"tenant_id": tenant_id, "agent_id": agent_id, "event": event}
