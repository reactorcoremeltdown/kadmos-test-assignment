PRIVATE_KEY=$(OPENSSH_PRIVATE_KEY)

all: tf_plan
	@echo "This is a template repository"

tf_plan:
	test -d /opt/terraform || mkdir /opt/terraform
	podman run -it \
		-e "TF_HTTP_USERNAME=$(TF_HTTP_USERNAME)" \
		-e "TF_HTTP_PASSWORD=$(TF_HTTP_PASSWORD)" \
		-w /mnt -v $(shell pwd)/terraform:/mnt \
		hashicorp/terraform:1.8 plan \
		-var="hcloud_token=$(HCLOUD_TOKEN)"

tf_apply:
	podman run -it \
		-e "TF_HTTP_USERNAME=$(TF_HTTP_USERNAME)" \
		-e "TF_HTTP_PASSWORD=$(TF_HTTP_PASSWORD)" \
		-w /mnt -v $(shell pwd)/terraform:/mnt \
		hashicorp/terraform:1.8 apply -auto-approve \
		-var="hcloud_token=$(HCLOUD_TOKEN)"
	mkdir -p ansible/inventory
	mv terraform/inventory.txt ansible/inventory

ansible_apply:
	mkdir -p ansible/.ssh
	chmod 700 ansible/.ssh
	mv id_rsa ansible/.ssh
	chown -R 1000:1000 ansible
	chmod 400 ansible/.ssh/id_rsa
	podman run -it \
		-e USER=ansible \
		-e ANSIBLE_HOST_KEY_CHECKING=false \
		-e MY_UID=1000 \
		-e MY_GID=1000 \
		-v $(shell pwd)/ansible/:/data/ \
		-v $(shell pwd)/ansible/.ssh/:/home/ansible/.ssh/ \
		cytopia/ansible:2.13-tools \
		ansible-playbook -i inventory/inventory.txt playbook.yaml

kubernetes_config:
	test -d /root/.kube || mkdir /root/.kube
	test -f ansible/k3s.yaml && cat ansible/k3s.yaml > /root/.kube/config
	chmod 600 /root/.kube/config
	kubectl get nodes

kubernetes_prometheus:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install --namespace=monitoring --create-namespace prometheus prometheus-community/prometheus
	helm upgrade --install --namespace=monitoring --create-namespace kube-metrics-adapter ./kubernetes/kube-metrics-adapter

kubernetes_apply:
	helm upgrade --install --namespace=kadmos-test --create-namespace kadmos-test ./kubernetes/kadmos-test

kubernetes_all: kubernetes_config kubernetes_prometheus kubernetes_apply

apply: tf_apply ansible_apply kubernetes_all
	@echo "Apply complete"
