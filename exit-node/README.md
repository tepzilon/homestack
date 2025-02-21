# opentofu

```
aws configure --profile homestack-iac
```

AWS KMS Encrypt

```
$ aws kms encrypt \
    --key-id 7129ecf7-823d-4dca-a8f1-7e0d8e3e2ce0 \
    --plaintext fileb://<(echo -n "text-to-encrypt") \
    --output text \
    --query CiphertextBlob
```

AWS KMS Decrypt

```
$ aws kms decrypt \
    --key-id 7129ecf7-823d-4dca-a8f1-7e0d8e3e2ce0 \
    --ciphertext-blob fileb://<(echo -n "text-to-decrypt" | base64 --decode) \
    --output text \
    --query Plaintext \
    | base64 --decode
```

# ansible

Generate hashed password

```
$ pipx inject ansible passlib
$ ansible all -i localhost, -m debug -a "msg={{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"
```

Play

```
$ ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass
```

# Secret hint

- Exit node SSH key pair
  - secrets/homestack-exit-node-ssh-key
  - secrets/homestack-exit-node-ssh-key.pub
- Exit node user `tepzilon` password
  - ansible/secrets/user-tepzilon-password
- OCI `homestack-iac` private key
  - opentofu/secrets/homestack-iac-YYYY-MM-DDT_XX_XX.XXXZ.pem
- Cloudflare API token
  - opentofu/secrets/cloudflare-api-token
- Backup AWS credentials (optional)
  - opentofu/secrets/backup-aws-credentials
