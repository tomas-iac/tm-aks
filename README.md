# tm-aks
Terraform module - AKS

## Module testing

```bash
cd examples/local
terraform validate
terraform plan
terraform apply -auto-approve
```

## Tests
cd tests
go mod init aks
go get github.com/gruntwork-io/terratest/modules/terraform
go test -v -timeout 60m