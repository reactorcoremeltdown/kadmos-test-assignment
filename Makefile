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
