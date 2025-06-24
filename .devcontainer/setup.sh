#!/bin/bash
set -e

echo "[INFO] Installing dependencies..."
sudo apt-get update
sudo apt-get install -y curl git bash iptables conntrack socat ebtables apt-transport-https ca-certificates gnupg2

echo "[INFO] Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[INFO] Creating a k3d cluster..."
k3d cluster create demo-cluster --agents 1

echo "[INFO] Saving kubeconfig..."
mkdir -p ~/.kube
k3d kubeconfig get demo-cluster > ~/.kube/config
k3d kubeconfig get demo-cluster > /workspaces/Devops05/kubeconfig

echo "[INFO] Done! Cluster and config ready."
