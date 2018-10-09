#!/bin/sh

# download install k8s controller binaries
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl"

chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl

sudo cp kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/

# configure the k8s API Server

sudo mkdir -p /var/lib/kubernetes/

sudo cp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem encryption-config.yaml /var/lib/kubernetes/

INTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)

# Start the controller service

sudo cp kube-apiserver.service kube-scheduler.service kube-controller-manager.service /etc/systemd/system/

sudo systemctl daemon-reload

sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler

sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler

