# AWS NetworkFirewall Deployment

This repo contains initial code to setup base infrastructure for AWS Network Firewall.
We are covering 1x use case for inspecting traffic across private workloads out of multiple as show cased in AWS documentation.

- Network module have some interesting content. Please read it well.

### Note:
- The script will create +/- 39 resources and may cross the free tier usage limit.
- The end user should be able to ping any outside domain from linux machine commandline once deployment is completed.


### Reference ###

1. https://aws.amazon.com/blogs/networking-and-content-delivery/deployment-models-for-aws-network-firewall/