#!/bin/bash
# run.sh - Full Kubernetes master node setup

set -euo pipefail

echo "[*] Starting full Kubernetes master node setup..."

bash precheck.sh
bash linux/setup-linux.sh
bash linux/init-master.sh
bash install-cni.sh

echo "[✓] Kubernetes master node setup complete."