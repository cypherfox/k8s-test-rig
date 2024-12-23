# Directory, where all required tools are located (absolute path required)
BUILD_PATH ?= $(shell pwd)
TOOLS_DIR  ?= $(shell cd tools 2>/dev/null && pwd)


VERSION    := 0.1.0-dev1
TIME       := $(shell date)
GO_MODULE  := github.com/cypherfox/k8s-test-rig
GO_VERSION := 1.18
LDFLAGS    := "-extldflags=-static -X '$(GO_MODULE)/pkg/version.BuildTime=$(TIME)' -X '$(GO_MODULE)/pkg/version.BuildVersion=$(VERSION)'"


#docker-image:
#	docker build -f deploy/docker/bugsim/Dockerfile --build-arg GO_VERSION=$(GO_VERSION) --build-arg VERSION=$(VERSION) -t localhost:5001/bugsim:$(VERSION) .
#
#bin/bugsim: cmd/bugsim/main.go pkg/k8s/client.go cmd/bugsim/cmd/root.go cmd/bugsim/cmd/server.go Makefile
#	CGO_ENABLED=0 go build -o bin/bugsim -ldflags=$(LDFLAGS) ./cmd/bugsim

#helm-full-lint:
#	docker run -it --rm  \
#	    --volume $(PWD)/test/data/helm/ct.yaml:/etc/ct/ct.yaml \
#		--volume $(PWD):/data \
#		quay.io/helmpack/chart-testing:v3.5.0 \
#	  ct lint --charts /data/deploy/helm/cloud-native-demo \
#	    --chart-repos grafana=https://grafana.github.io/helm-charts \
#		--chart-repos linkerd=https://helm.linkerd.io/stable \
#		--config /etc/ct/ct.yaml \
#		--debug --print-config

helm-package:
	make -C deploy/helm package

# Linkerd CRDs will be deployed as a child Helm Chart.
deploy-crds:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.crds.yaml
	kubectl apply --server-side --force-conflicts -f https://github.com/grafana/grafana-operator/releases/download/v5.15.1/crds.yaml


k8s-namespaces: 
	kubectl create namespace cert-manager 
	kubectl create namespace linkerd 
	kubectl create namespace monitoring

helm-deploy:
	step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca \
       --no-password --insecure --force
	step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
       --profile intermediate-ca --not-after 8760h --no-password --insecure \
       --ca ca.crt --ca-key ca.key --force
	helm upgrade test-rig ./deploy/helm/k8s-test-rig --debug \
      --install --namespace test-rig --create-namespace --devel \
      --set-file linkerd-control-plane.identityTrustAnchorsPEM=ca.crt \
      --set-file linkerd-control-plane.identity.issuer.tls.crtPEM=issuer.crt \
      --set-file linkerd-control-plane.identity.issuer.tls.keyPEM=issuer.key

kind-load: docker-image
	kind load docker-image localhost:5001/bugsim:$(VERSION)

# to quickly update the container running in the kind cluster
kind-update-running-version:
	kubectl patch deployment cloud-native-demo -p '{"template":{"spec":{"containers":[{"name":"cloud-native-demo","image":"localhost:5001/bugsim:$(VERSION)"}]}}}'

check-setup:
	if ! test -d /var/local-path-provider || echo "directory for local storage >>var

.PHONEY: kind-load docker-image helm-lint


include helm.mk
include go.mk


