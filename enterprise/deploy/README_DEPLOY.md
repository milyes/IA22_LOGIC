# ETAPE 18 - Deploiement Enterprise

## Docker Compose
docker-compose -f docker-compose.enterprise.yml up -d
curl -k https://localhost:8443/healthz

## Kubernetes
kubectl apply -f kubernetes.yaml

## VM ISO
Flasher NetSecurePro-ZCORE-22.0.0.iso
Autoinstall lance hardening.sh

## Checklist
- TLS cert
- KMS/HSM
- SIEM endpoint
- Tenant isolation
- Audit immuable
