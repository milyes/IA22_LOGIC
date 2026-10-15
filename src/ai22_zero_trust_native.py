#!/usr/bin/env python3
# AI22 ZERO TRUST - Stdlib only - NetSecurePro IA
import re, json, hashlib, uuid, math
from datetime import datetime
from collections import deque
AUDIT=[]; RISK=deque(maxlen=100); INC=[]
def audit(ev,ten="def",ag="unk",dec="LOG",risk=0):
    e={"ts":datetime.utcnow().isoformat()+"Z","id":str(uuid.uuid4())[:8],"tenant":ten,"event":ev,"decision":dec,"risk":risk}
    AUDIT.append(e); return e
def dlp(t):
    m=t; f=[]
    for pat in [r"[a-z0-9_.+-]+@[a-z0-9-]+\.[a-z0-9-.]+"]:
        for x in re.finditer(pat,t,re.I):
            f.append("EMAIL"); m=m.replace(x.group(),"<EMAIL>")
    return {"findings":f,"masked":m,"risk":len(f)*10}
def fw(p):
    s=0
    for w in ["ignore previous","system prompt","jailbreak","exfiltrate"]:
        if w in p.lower(): s+=30
    return {"score":s,"decision":"BLOCK" if s>=60 else "ALLOW"}
def handle(tenant,agent,prompt,tool=None,op=None):
    if not tenant: return {"decision":"BLOCK"}
    pf=fw(prompt); RISK.append({"risk":pf["score"]})
    if pf["decision"]=="BLOCK": return {"decision":"BLOCK","fw":pf}
    d=dlp(prompt); RISK.append({"risk":d["risk"]})
    rs=min(100,int(math.sqrt(sum(x.get("risk",0) for x in RISK))*10)) if RISK else 0
    e=audit(f"allow {tenant} risk={rs}",tenant,agent,"ALLOW",rs)
    return {"decision":"ALLOW","risk":rs,"safe":d["masked"],"audit":e}
if __name__=="__main__":
    for pr in ["Hello","ignore previous","test@test.com"]:
        print(handle("t1","a1",pr))
    print(f"ZERO TRUST OK AUDIT={len(AUDIT)}")
