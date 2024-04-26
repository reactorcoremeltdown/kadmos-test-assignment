OPENSSH_PRIVATE_KEY=$(OPENSSH_PRIVATE_KEY)

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
	echo "$(OPENSSH_PRIVATE_KEY)" > ansible/.ssh/id_rsa
	chmod 400 ansible/.ssh/id_rsa
	podman run -it \
		-v $(shell pwd)/ansible:/home/ansible \
		cytopia/ansible:2.13-tools \
		ansible-playbook -i inventory/inventory.txt playbook.yaml

apply: tf_apply ansible_apply
	@echo "Apply complete"
