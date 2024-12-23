# k8s-test-rig
Set up a managed k8s service offering with no external dependencies.

This includes
* [Linkerd](https://github.com/linkerd/linkerd2)
* [external-secrets](https://github.com/external-secrets/external-secrets)
* [external-dns](https://github.com/kubernetes-sigs/external-dns)
* [cert-manager](https://github.com/cert-manager/cert-manager)
* [loki](https://github.com/grafana/loki)
* [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)
* [grafana-operator](https://github.com/grafana-operator/grafana-operator)
* (CoreDNS) - already present in virtually all Kubernetes clusters.
* HashiCorp Vault

all set up from a single helm chart.

This is intended to provide a complete managed kubernetes suite to be used in local test setups or air-gapped environments.

The setup does not scale, does not provide real security. It is not suited for production-use by design.
It may also be useful in a home- lab or home automation setting.

## Similar Packages

The [Big Bang] project of the DoD Platform One aims for a similar goal as the K8s test rig, but has a larger scope. 
It allows the resultant workload setups to be actually be used in production and needs some prerequisite setup to 
provide the the security requirements and hardening that a security sensitive environment like the military requires.

## Prerequisites

You need the following commands installed localy on your computer:

* **make**: Build control tool. If it is not installed already, check the basic development tools of your OS distribution. E.g. the package `build-essentials` on Ubuntu
* **helm**: Check the [installation instructions](https://helm.sh/docs/intro/install/)
* **kubectl**: Check the [installation instructions](https://kubernetes.io/docs/tasks/tools/)
* **smartcli**
* **kind**

## Deploy Stack

This will create a new kind cluster of the name `my-cluster`

```
export CLUSTER_NAME="my-cluster" && make helm-package && kind create cluster -name $CLUSTER_NAME -config kind-conf.yaml && make deploy-crds k8s-namespaces helm-deploy
```
