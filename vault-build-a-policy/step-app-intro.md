```
               __
    ..=====.. |==|
    ||     || |= |
 _  ||     || |^*| _
|=| o=,===,=o |__||=|
|_|  _______)~`)  |_|
    [=======]  ()
```

The appliation, or app, is a non-human client that requires secrets like API
keys, database credentials, or encryption-as-a-service. Web applications
typically authenticate through an `approle`. To make exploration easier
`userpass` is enabled and a user names `apps` was created.

Show the `apps` user.

```shell
vault read auth/userpass/users/apps
```{{execute}}

The `apps` user is assigned two policies. The `apps-policy` policy is the one
that you manage.

Show the `apps-policy` policy.

```shell
vault policy read apps-policy
```{{execute}}

The policy contains comments about future application requirements.

As the Vault server only maintains the latest version of the policy. A local
copy of the policy is maintained on this workstation.

Show the `apps-policy.hcl` file.

```shell
cat apps-policy.hcl
```{{execute}}

This file matches the contents defined on the Vault server.

You are ready to implement the application's requirements.