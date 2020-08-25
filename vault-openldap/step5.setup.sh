vault login root

vault policy write alice-policy alice-policy.hcl

vault write auth/userpass/users/alice \
  password=alice-password \
  policies=alice-policy

rm /root/.vault-token