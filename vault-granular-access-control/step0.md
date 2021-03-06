The Postgres database is started in a Docker container.

```shell
docker ps --filter name=postgres
```{{execute}}

Wait until this command displays a running `postgres` container.

The Vault server is running locally in development mode.

Export an environment variable for the `vault` CLI to address the target Vault
server.

```shell
export VAULT_ADDR=http://localhost:8200
```{{execute}}


Display the status of the target Vault server.

```shell
vault status
```{{execute}}

Wait until this command displays a running Vault server.

The response shows that the Vault server is initialized and unsealed.

The server writes its operation logs and audit log to the file system.

Open the audit logs stored in `log/vault_audit.log`{{open}}.

The file audit log writes JSON objects to the log file. The `jq` command parses,
filters and presents that data to you in a more digestable way.
