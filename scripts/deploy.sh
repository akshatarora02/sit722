#
# Runs Terraform to provision a Kubernetes cluster and deploy microservices to it.
#

set -u # or set -o nounset
: "$VERSION"

cd ./scripts
export KUBERNETES_SERVICE_HOST="" # Workaround for https://github.com/terraform-providers/terraform-provider-kubernetes/issues/679
terraform init 
terraform apply -auto-approve \
    -var "app_version=$VERSION" 