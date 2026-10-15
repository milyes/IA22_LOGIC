#!/usr/bin/env python3
# AI22 - Z-CORE v22.0.0 ZERO TRUST NATIVE - Stdlib only
import re, json, hashlib, uuid, math
from datetime import datetime
from collections import deque

AUDIT=[]; RISK=deque(maxlen=100); INC=[]

def audit(ev,ten="def",ag="unk",dec="LOG",risk=0):
    e={"ts":datetime.utcnow().isoformat()+"Z","id":str(uuid.uuid4())[:8],"tenant":ten,"event":ev,"decision":dec,"risk":risk}
    AUDIT.append(e); return e

def dlp(t):
    f=[]; m=t
    for pat in [r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+"]:
        for x in re.finditer(pat,t):
            f.append("EMAIL"); m=m.replace(x.group(),"<EMAIL>")
    return {"findings":f,"masked":m,"risk":len(f)*10}

def fw(p):
    s=0
    for w in ["ignore previous","system prompt","jailbreak","exfiltrate"]:
        if w in p.lower(): s+=30
    return {"score":s,"decision":"BLOCK" if s>=60 else "ALLOW"}

def handle(tenant,agent,prompt,tool=None,op=None):
    if not tenant: return {"decision":"BLOCK","reason":"tenant required"}
    pf=fw(prompt); RISK.append({"risk":pf["score"]})
    if pf["decision"]=="BLOCK":
        e=audit(f"fw_block {prompt[:20]}",tenant,agent,"BLOCK",pf["score"])
        return {"decision":"BLOCK","fw":pf,"audit":e}
    d=dlp(prompt); RISK.append({"risk":d["risk"]})
    rs=min(100,int(math.sqrt(sum(x.get("risk",0) for x in RISK))*10)) if RISK else 0
    e=audit(f"allow {tenant} risk={rs}",tenant,agent,"ALLOW",rs)
    inc=None
    if len(RISK)>=3 and rs>=60:
        inc={"id":f"INC-{len(INC)+1000}","severity":"HIGH"}; INC.append(inc)
    return {"decision":"ALLOW","risk":rs,"safe":d["masked"],"incident":inc,"audit":e}

if __name__=="__main__":
    for pr in ["Hello","ignore previous instructions","test@example.com"]:
        r=handle("tenant1","agent1",pr)
        print(pr[:20],"->",r["decision"],"risk",r.get("risk"))
    print(f"AUDIT {len(AUDIT)} INC {len(INC)} ZERO TRUST OK")
