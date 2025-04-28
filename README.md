# AWS Network Firewall Deployment

This repository contains Terraform code to deploy AWS Network Firewall in a centralized inspection architecture. The implementation focuses on inspecting traffic from private workloads to the internet, which is one of the common deployment models for AWS Network Firewall.

## Architecture Overview

The deployment creates the following components:

- **VPC**: A VPC with CIDR block 172.31.0.0/16
- **Subnets**:
  - Firewall subnet (172.31.1.0/24) - Hosts the AWS Network Firewall endpoints
  - Workload subnet (172.31.2.0/24) - Hosts private EC2 instances
  - NAT Gateway subnet (172.31.3.0/24) - Hosts the NAT Gateway for outbound traffic

- **Network Components**:
  - AWS Network Firewall with stateful and stateless rule groups
  - NAT Gateway for outbound internet access
  - Internet Gateway for inbound/outbound connectivity
  - Custom route tables to direct traffic through the firewall
  - S3 VPC endpoint for private access to S3

- **Compute Resources**:
  - EC2 instance (t2.micro) in the private workload subnet
  - Security groups with rules for HTTP, HTTPS, SSH, RDP, and ICMP traffic

- **IAM Resources**:
  - IAM roles and policies for EC2 instance access
  - VPC Endpoints for AWS services (SSM, EC2 Messages, SSM Messages)

## Network Flow

The architecture implements a centralized inspection model where:

1. Outbound traffic from private instances in the workload subnet is routed to the NAT Gateway
2. Traffic from the NAT Gateway is routed through the Network Firewall for inspection
3. Inspected traffic is then forwarded to the Internet Gateway for internet access
## Firewall Rules

The deployment includes:

1. **Stateful Rule Group**: Permits ICMP traffic from any source
   - Action: PASS
   - Protocol: ICMP
   - Direction: ANY
   - Source: ANY

2. **Stateless Rule Group**: Allows ICMP traffic (protocol 1)
   - Priority: 1
   - Source: 0.0.0.0/0
   - Destination: 0.0.0.0/0
   - Action: aws:pass4. Return traffic follows the reverse path, being inspected by the firewall before reaching the private instances
5. The firewall is configured to allow ICMP traffic (ping) to demonstrate connectivity

## Routing Configuration

The deployment implements a sophisticated routing configuration:

1. **Private Route Table**: Routes traffic from workload subnet (172.31.2.0/24) to the NAT Gateway
2. **NAT Gateway Route Table**: Routes traffic from NAT Gateway subnet (172.31.3.0/24) through the Network Firewall
3. **Firewall Route Table**: Routes traffic from firewall subnet (172.31.1.0/24) to the Internet Gateway
4. **Edge Association Route Table**: Routes traffic from the Internet Gateway to the appropriate subnets through the Network Firewall

This routing configuration ensures all traffic is properly inspected while maintaining connectivity.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 0.12+)
- Basic understanding of AWS networking concepts

## Deployment Instructions

1. Clone this repository
2. Review and modify the `terraform.tfvars` file if needed
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Plan the deployment:
   ```
   terraform plan
   ```
5. Apply the configuration:
   ```
   terraform apply
   ```

## Testing Connectivity

Once deployed, you can connect to the EC2 instance in the private subnet using AWS Systems Manager Session Manager and test connectivity by pinging external domains.

Example:
```
ping google.com
```

## Important Notes

- This deployment creates approximately 39 AWS resources and may exceed AWS free tier limits.
- The architecture is designed for demonstration purposes and may need adjustments for production use.
- Security groups are configured with permissive rules for demonstration - restrict these for production use.
- The EC2 instance is configured with SSM access for management without requiring direct SSH access.

## Reference Architecture

This implementation is based on the centralized inspection model described in AWS documentation:

1. [Deployment Models for AWS Network Firewall](https://aws.amazon.com/blogs/networking-and-content-delivery/deployment-models-for-aws-network-firewall/)
2. [AWS Network Firewall Documentation](https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html)

## Clean Up

To avoid ongoing charges, remember to destroy the resources when they're no longer needed:

```
terraform destroy
```
