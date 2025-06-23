#!/bin/bash
# precheck.sh - System prerequisites for Kubernetes

set -euo pipefail

echo "[*] Running system pre-checks..."

if free | awk '/^Swap:/ {exit !$2}'; then
  echo "[!] Swap is enabled, disabling..."
  sudo swapoff -a
  sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
else
  echo "[OK] Swap is disabled."
fi

echo "[*] Loading kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

echo "[*] Setting sysctl params for Kubernetes networking..."

cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

echo "[*] Pre-checks complete."