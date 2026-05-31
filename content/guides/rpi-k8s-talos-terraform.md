---
icon: simple/kubernetes
description: Build a Kubernetes cluster with Raspberry Pi, Talos and Terraform.
---

# K8s on RPI with Talos and Terraform

[:octicons-mark-github-16: View repo](https://github.com/aceat64/rpi-k8s-talos-terraform){ .md-button .md-button }

This repo is a fully working example of deploying a Kubernetes cluster to a handful of Raspberry Pi 4s. We use [Talos](https://talos.dev)
for the OS and building the Kubernetes cluster. After the cluster is bootstraped, we use Terraform deploy various useful services onto the cluster.

## Features

At the end of this tutorial you'll have a fully working Kubernetes cluster with the following services configured and ready to use:

- [Talos](https://talos.dev) - Minimal and hardened operating system and tools that deploy and manage kubernetes nodes/clusters.
    - Virtual (shared) IP address for the talos and Kubernetes endpoints
- [MetalLB](https://metallb.universe.tf) - Load balancers using virtual/shared IPs
- [metrics-server](https://github.com/kubernetes-sigs/metrics-server) - Provide metrics for Kubernetes autoscaling (e.g. horizontal pod autoscaler)
- [cert-manager](https://cert-manager.io/) - Automated TLS certificate management
- [Rook-Ceph](https://rook.io/) - Distributed block, object and file storage
- [Prometheus](https://prometheus.io/) - Monitoring and alerting
    - Full monitoring of your cluster! We gather metrics from just about every service that has them.
- [Loki](https://grafana.com/oss/loki/) - Log aggregation
- [Grafana](https://grafana.com/oss/grafana/) - Visualize and explore metrics, logs and other data. \* Since we use the [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) helm chart a bunch of dashboards are pre-generated for you. We also automatically deploy dashboards for monitoring rook-ceph.
- [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) - Send Prometheus alerts to email, PagerDuty, etc.
- [Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) - Suggest or automatically adjust resource limits and requests for pods.

## Helm Charts and Terraform Modules Used

- [cert-manager](https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm) v1.3.1
- [metrics-server](https://github.com/helm/charts/tree/master/stable/metrics-server) 2.11.4
- [vpa](https://artifacthub.io/packages/helm/fairwinds-stable/vpa) 0.3.2
- [loki-stack](https://grafana.com/docs/loki/latest/installation/helm/) 2.3.1
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) 15.3.1
- [rook-ceph](https://github.com/rook/rook/blob/master/Documentation/helm-operator.md) v1.6.1
- [terraform-kubernetes-metallb](https://github.com/colinwilson/terraform-kubernetes-metallb) v0.1.6
