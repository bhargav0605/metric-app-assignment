#!/bin/bash
set -e

CLUSTER_NAME="kind-argocd"

echo "🌀 Creating KIND cluster: $CLUSTER_NAME"
cat <<EOF | kind create cluster --name $CLUSTER_NAME --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
EOF

echo "✅ KIND cluster '$CLUSTER_NAME' created."

echo "🌐 Installing Argo CD in 'argocd' namespace..."
kubectl create namespace argocd || true

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "⏳ Waiting for Argo CD server to be ready..."
kubectl wait deployment argocd-server -n argocd --for=condition=Available=True --timeout=120s

echo "🔐 Getting Argo CD initial admin password..."
ARGOCD_PWD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)

echo -e "\n✅ Argo CD UI is ready at: http://localhost:8080"
echo "➡️ Login with username: admin"
echo "➡️ Password: $ARGOCD_PWD"

echo "🎯 Port-forwarding Argo CD UI to localhost:8080..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &

# Deploy Argo CD Guestbook Demo Application
echo "📦 Deploying Argo CD Guestbook demo application..."

cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

echo "✅ Guestbook application deployed via Argo CD!"
