# Kadmos test assignment

A repository with full-stack IaC required to get Kadmos test application up and running on Hetzner cloud.

## Structure

Below the structure of Kadmos test app IaC described:

### CI

Kadmos test app utilizes Drone CI as a continuous integration service. Each commit to main branch results in a dry-run action. The pipeline description is contained in [.drone.yml](/.drone.yml) file at the root of the source code tree. The CI engine makes a shallow copy of the git repository and then runs stages as described.

+ The `default` pipeline with no promotion tags runs `terraform plan` using a designated Hetzner API key from CI engine secrets
    + In order to apply all changes, an operator needs to promote the current release to `apply` target
    + If only the application's Helm chart needs an update, a promotion to `kube` target should work, unless there are no VMS and clusters provisioned
+ The `report` pipeline sends the result of the `default` pipeline run to Telegram to notify an operator

The Kadmos test app IaC repo uses `Makefile` as an entrypoint

### Terraform

The terraform subtree of this repo contains all manifests required to setup VMs, SSH keys, and firewall rules for further provisioning. The private counterpart of an SSH key is stored securely in DRONE CI secrets & retrieved when needed.

There are two virtual machines currently provisioned: one for hosting a reverse proxy, the other one for hosting a kubernetes cluster, acting as an upstream for the aforementioned reverse proxy. Both machines run Debian 12 operating system. The state file of Terraform repo is kept remotely on a WebDAV server, making it possible to run the pipeline on different CI workers. The credentials of a WebDAV server are also stored in Drone CI secrets and retrieved as needed.

After a successful apply, Terraform composes an Ansible inventory file to pass to another Makefile target.

### Ansible

The job of Ansible subtree of this repository is to provision Nginx as a reverse proxy on one server, and to install K3s(a Kubernetes implementaton) on another server. The Nginx config file is provisioned from a template, where upstream server names are extracted from `kubernetes` inventory group.

After K3s server installation is complete, Ansible extracts the `/etc/rancher/k3s/k3s.yaml` and stores it as `~/.kube/config` for later consumption by Helm and `kubectl` command.

### Kubernetes and Helm

The Kubernetes subtree of this repository performs following actions in sequence:

+ Installs prometheus for metrics scraping
+ Installs and configures kube-metrics-adapter by Zalando for external HPA metrics handling
+ Installs kadmos-test helm chart containing following components:
    + The deployment of Nginx container
    + The ingress for letting traffic in (implemented by Traefik)
    + The service pointing at the deployment
    + The HPA that uses custom metrics as a reference for autoscaling actions
