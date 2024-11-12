# Steps
1. `aws configure --profile homestack-iac`
2. `pulumi login "s3://homestack-pulumi-state?profile=homestack-iac"`

# Credentials checklist
- Pulumi IaC
  - Stack `prod` passphrase
- AWS account `tepzilon`
  - IAM user `homestack-iac`
    - Access key ID
    - Secret access key
- OCI tenant `tepzilon`
  - User `homestack-iac`
    - API Keys
      - Private/Public key pairs
    - Exit node SSH key pair


