# Terraform Hello World

This is a minimal Terraform example that prints a greeting as an output.

## Usage

```sh
terraform init
terraform apply -auto-approve
terraform output hello_world
```

To customize the greeting:

```sh
terraform apply -auto-approve -var='name=Terraform'
terraform output hello_world
```
