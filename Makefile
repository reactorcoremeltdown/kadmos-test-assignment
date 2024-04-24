all: tf_plan
	@echo "This is a template repository"

tf_plan:
	podman run -it -w /data -v terraform:/data hashicorp/terraform:1.8 plan
