all: tf_plan
	@echo "This is a template repository"

tf_plan:
	podman run -it -w /mnt -v $(shell pwd)/terraform:/mnt -v /opt/terraform:/opt/terraform hashicorp/terraform:1.8 plan -var="hcloud_token=$(HCLOUD_TOKEN)"

tf_apply:
	podman run -it -w /mnt -v $(shell pwd)/terraform:/mnt -v /opt/terraform:/opt/terraform hashicorp/terraform:1.8 apply -auto-approve -var="hcloud_token=$(HCLOUD_TOKEN)"
