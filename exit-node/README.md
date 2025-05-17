# Opentofu

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

# Ansible

Generate hashed password

```
$ pipx inject ansible passlib
$ ansible all -i localhost, -m debug -a "msg={{ 'mypassword' | password_hash('sha512', 'mysecretsalt') }}"
```

Play

```
$ ansible-playbook -i inventory.ini playbook.yaml --ask-become-pass
```

# Services

## Wireguard

PersistentKeepalive: 25

- Exit node
  - Interface
    - Remove DNS
      - Since it'll then call `resolvctl -a homestack -m 0 -x`
      - Caused adding `nameserver X.X.X.X` to the file `/run/systemd/resolve/resolv.conf`
      - Then the exit node will not be able to access to internet (somehow cannot resolve DNS)
  - Peer
    - Since peers are clients, so allowed IP has to be 10.8.0.0/24 (only packets with 10.8.x.x will route to peers)
    - (nit) Endpoint should be 127.0.0.1:51820 or localhost:51820
- Clients
  - Peer
    - Since peer is the exit node, so allowed IP is 0.0.0.0/0 (route every packets through VPN)

# Secret hint

- exit-node
  - secrets
    - homestack-exit-node-ssh-key
    - homestack-exit-node-ssh-key.pub
  - ansible
    - secrets
      - user-tepzilon-password
  - opentofu
    - secrets
      - backup-aws-credentials
      - cloudflare-api-token
      - homestack-iac-YYYY-MM-DDT_XX_XX.XXXZ.pem (OCI)
  - services
    - secrets
      - wg-dell-notebook
        - homestack.conf
      - wg-exit-node
        - homestack.conf
      - portainer-admin-password
      - wg-easy-admin-password
