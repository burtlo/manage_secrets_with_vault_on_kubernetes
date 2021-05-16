# Start the Postgres server

docker pull postgres:latest

docker run \
      --name postgres \
      --env POSTGRES_USER=root \
      --env POSTGRES_PASSWORD=rootpassword \
      --detach  \
      --publish 5432:5432 \
      postgres

docker exec -it postgres psql -c "CREATE ROLE ro NOINHERIT;"
docker exec -it postgres psql -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO "ro";"

# Start the Vault server in the background
mkdir -p ~/log
nohup sh -c "vault server -dev -dev-root-token-id="root" -dev-listen-address=0.0.0.0:8200 >~/log/vault.log 2>&1" > ~/log/nohup.log &

sleep 5

ufw allow 8200/tcp

export VAULT_ADDR=http://0.0.0.0:8200

# Login as root and create a userauth endpoint for the admin and apps of the
# scenario.

vault login root

vault policy write admin-policy admin-policy.hcl

vault auth enable userpass

vault write auth/userpass/users/admin \
  password=admin-password \
  policies=admin-policy

vault policy write apps-policy apps-policy.hcl

vault write auth/userpass/users/apps \
  password=apps-password \
  policies=apps-policy

rm /root/.vault-token

# Create KV-V2 secrets engine

vault secrets enable kv-v2 -path=socials
vault kv put socials/twitter api_key=MQfS4XAJXYE3SxTna6Yzrw api_secret_key=uXZ4VHykCrYKP64wSQ72SRM10WZwirnXq5rmyiLnVk

# Create database secrets engine

vault secrets enable database -path=database

vault write database/config/postgresql \
    plugin_name=postgresql-database-plugin \
    connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \
    allowed_roles=readonly \
    username="root" \
    password="rootpassword"

vault write database/roles/readonly \
    db_name=postgresql \
    creation_statements=@readonly.sql \
    default_ttl=1h \
    max_ttl=24h

# Create transit secrets engine

vault secrets enable transit -path=transit
vault write -f transit/keys/webapp-auth