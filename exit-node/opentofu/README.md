Setup

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

Secret hint

- OCI `homestack-iac` private key
  - secrets/homestack-iac-YYYY-MM-DDT_XX_XX.XXXZ.pem
- Cloudflare API token
  - secrets/cloudflare-api-token
- Exit node SSH key pair
  - ../secrets/homestack-exit-node-ssh-key
  - ../secrets/homestack-exit-node-ssh-key.pub
