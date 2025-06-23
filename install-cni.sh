#!/bin/bash
# install-cni.sh - Installs Calico CNI plugin

set -euo pipefail

echo "[*] Installing Calico CNI plugin..."

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

echo "[*] Calico CNI installed successfully."