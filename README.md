# Kubernetes Bootstrap Kit

A secure, automated, and reusable kit to bootstrap `kubeadm`-based Kubernetes clusters with confidence.

## Features

```
- Pre-check system requirements (swap, kernel modules, sysctl)
- Install Docker & Kubernetes (kubeadm, kubelet, kubectl)
- Auto-initialize Kubernetes master & generate join script
- Installs Calico CNI networking
- Linux + (planned) Windows support
- Reusable, shareable, production-ready setup
```

## Usage

## 🚀 Quick Start (Linux Only)

This guide assumes you're using **Ubuntu Linux** (22.04 or newer). For cloud setups like AWS EC2, ensure all instances (master and workers) are in the same VPC/subnet and can reach each other.

---

### Run this on **all nodes** (master + workers):

```bash
bash precheck.sh
bash linux/setup-linux.sh
```

**What this does:**

* Disables swap (required by Kubernetes)
* Loads necessary kernel modules
* Installs Docker, kubeadm, kubelet, and kubectl (pinned version 1.28)
* Adds apt repositories for Docker and Kubernetes

**Note:**
Some keys and URLs (e.g., GPG keys, version numbers) **may expire or change**. Always refer to the official documentation if setup fails.

* Docker: [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)
* Kubernetes: [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://  kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

---

2️⃣ On the **master node only**:

```bash
bash linux/init-master.sh
bash install-cni.sh
```

**What this does:**

* Initializes the Kubernetes control plane using `kubeadm init`
* Sets up kubeconfig for your current user
* Generates a `join.sh` file for workers to join the cluster
* Installs Calico CNI for networking

---

3️⃣ On each **worker node**, run the `join.sh` from master:

```bash
bash join.sh
```

Copy the `join.sh` file from your master node to each worker node. This script contains a secure token and IP needed to join the cluster.

---

⚡ Or just use the one-liner (on master node):

```bash
./run.sh
```

Runs all setup steps on the master in order:

* Pre-checks
* Install dependencies
* Init master
* Install CNI

---

## Required Network Ports

Ensure the following ports are open between your nodes (especially for cloud environments like AWS, GCP, etc.):

| Port        | Protocol | Used By                 | Direction       |
| ----------- | -------- | ----------------------- | --------------- |
| 6443        | TCP      | Kubernetes API          | Worker → Master |
| 2379-2380   | TCP      | etcd (control plane)    | Master ↔ Master |
| 10250       | TCP      | Kubelet                 | All nodes       |
| 10251       | TCP      | kube-scheduler          | Master only     |
| 10252       | TCP      | kube-controller-manager | Master only     |
| 30000-32767 | TCP      | NodePort Services       | As needed       |

**Cloud users:** Open these ports in your firewall or security group settings.

---

## Troubleshooting

* If `docker`, `kubeadm`, or `kubectl` commands are not found after install, reboot or re-login to reload shell permissions (especially for Docker group access).

* If the join command expires, regenerate it on the master with:

  ```bash
  kubeadm token create --print-join-command
  ```

* If Calico doesn't come up, check `kubectl get pods -n kube-system` and `kubectl describe pod <pod>` for logs.

---

## Author: \[Xolani Lan Shongwe]