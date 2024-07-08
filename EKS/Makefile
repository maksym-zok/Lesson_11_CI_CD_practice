SHELL := /bin/bash

update-argo-cd:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update
	kubectl get ns argo-cd || kubectl create ns argo-cd
	# helm upgrade --install argo-cd argo/argo-cd --version 7.3.4 --namespace argo-cd
	helm upgrade --install argo-cd argo/argo-cd --version 7.3.4 --values ./ArgoCD/values.yaml --namespace argo-cd
	kubectl apply -f ./ArgoCD/boilerplate-app.yaml