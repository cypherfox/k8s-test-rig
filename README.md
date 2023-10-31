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
* PowerDNS

all set up from a single helm chart.

This is intended to provide a complete managed kubernetes suite to be used in local test setups or air-gapped environments.

The setup does not scale, does not provide real security. It is not suited from production use by design.
