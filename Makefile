all: tf_plan
	@echo "This is a template repository"

tf_plan:
	podman run -it -w /mnt -v $(PWD)/terraform:/mnt hashicorp/terraform:1.8 plan
