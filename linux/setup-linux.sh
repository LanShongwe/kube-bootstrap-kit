#!/bin/bash
# setup-linux.sh - Sets up Docker and Kubernetes on Ubuntu (2025 updated)

set -euo pipefail

echo "[*] Updating package index..."
sudo apt-get update

echo "[*] Installing prerequisites..."
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

echo "[*] Adding Docker’s official GPG key and repo..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[*] Updating package index again..."
sudo apt-get update

echo "[*] Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[*] Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[*] Adding current user to docker group..."
sudo usermod -aG docker "$USER"

echo "[*] Disabling swap (required for Kubernetes)..."
sudo swapoff -a
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[*] Adding Kubernetes apt key and repo..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "[*] Updating package index again..."
sudo apt-get update

echo "[*] Installing kubelet, kubeadm, kubectl..."
sudo apt-get install -y kubelet=1.28.1-1.1 kubeadm=1.28.1-1.1 kubectl=1.28.1-1.1

echo "[*] Holding Kubernetes packages to prevent accidental upgrade..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "[*] Linux setup complete."
echo "⚠️ Please logout/login or reboot to apply Docker group permissions."