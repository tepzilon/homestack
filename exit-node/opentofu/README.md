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