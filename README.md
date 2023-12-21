# Clone repository
```
git clone git@github.com:alex86ns/task1.git && cd task1
```

# Terraform init

```
# only the first 2 variables are mandatory #

export TF_VAR_aws_secret_access_key="<secret_key>" \
export TF_VAR_aws_access_key_id="<access_key>" \
export TF_VAR_postgres_password="<your_pass_min_8_char>" \
export TF_VAR_vpc_name=vortex

terraform init 
terraform apply
```
