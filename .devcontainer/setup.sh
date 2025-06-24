#!/bin/bash
set -e

echo "[INFO] Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "[INFO] Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[INFO] Creating cluster..."
k3d cluster create demo-cluster --agents 1

echo "[INFO] Saving kubeconfig..."
mkdir -p ~/.kube
k3d kubeconfig get demo-cluster > ~/.kube/config
k3d kubeconfig get demo-cluster > /workspaces/Devops05/kubeconfig

echo "[INFO] Cluster nodes:"
kubectl get nodes
