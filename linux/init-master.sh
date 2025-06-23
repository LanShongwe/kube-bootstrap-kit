#!/bin/bash
# init-master.sh - Initializes Kubernetes master node

set -euo pipefail

echo "[*] Initializing Kubernetes master node with pod network CIDR 192.168.0.0/16..."

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 | tee kubeadm-init.log

echo "[*] Setting up kubeconfig for current user..."

mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

echo "[*] Generating join command..."

JOIN_CMD=$(sudo kubeadm token create --print-join-command)
echo "#!/bin/bash" > ../join.sh
echo "$JOIN_CMD" >> ../join.sh
chmod +x ../join.sh

echo "[*] Kubernetes master node initialized successfully."