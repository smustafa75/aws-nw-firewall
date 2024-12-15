# Project infrastructure for AWS NetworkFirewall

This repo contains initial code to setup base infrastructure for AWS Network Firewall.

- Replace the TFVARS content carefully as it may have very high cost impact.
- Compute module have some interesting content. Please read it.

### Note:
The script will create +/- 49 resources and may cross the free tier usage limit.

### Terraform Version ###
Terraform v1.1.2
+ provider registry.terraform.io/hashicorp/aws v3.71.0
+ provider registry.terraform.io/hashicorp/random v3.1.0
+ provider registry.terraform.io/hashicorp/template v2.2.0

