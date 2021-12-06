# tm-aks
Terraform module - AKS

## Module testing

```bash
terraform validate
terraform plan
terraform apply -auto-approve
```

## Tests
export GOPATH=$(pwd)
cd ./src/tests
dep init