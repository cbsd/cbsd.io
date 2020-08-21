# What nodes is meant

**node command**

```
% cbsd node
```
"Node addition" is meant RSA key exchange for system user CBSD between two and more hosts. Having at itself RSA a key of the individual server, the some command has an opportunity to work with it through OpenSSH connection, carrying out such actions as:

* executable remote CBSD (get jail list, login into jail) or unprivileged OS command (some commands, nevertheless, demand existence of the rights of the superuser. Such command are started through the scripts being in catalogs `$workdir/sudoexec` and `$prefix/cbsd/*ver*/sudoexec/` (distrib directory) — look at `/usr/local/etc/sudoers.d/cbsd_sudoers`.
* copying/creation of configuration files for jails, replication and synchronization of data.

Nodes can be united in any called logic group over which it is possible to carry out mass actions
