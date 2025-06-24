#!/bin/bash

set -e

echo "[INFO] Installing dependencies..."
apt-get update
apt-get install -y curl git sudo bash iptables conntrack socat ebtables apt-transport-https ca-certificates gnupg2

echo "[INFO] Installing k3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "[INFO] Creating a k3d cluster..."
k3d cluster create demo-cluster --agents 1

echo "[INFO] Testing cluster..."
kubectl get nodes
