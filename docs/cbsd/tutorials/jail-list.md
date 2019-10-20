# Jails list

**jls command**

```
% cbsd jls
```
**Description:**

Show the list of jails on a local node or for all added nodes. Through argument display you can specify the fields for output data. If display is not specified, the value takes from `$workdir/etc/defaults/jls.conf` file, which you can change at its discretion via `$workdir/etc/jls.conf`

All possible options for the sample described in the `$workdir/share/jail-arg` file

*  **JID** — Jail ID
*  **JNAME** — jail name
*  **IP4_ADDR** — list of assigned IP addresses (IPv4,IPv6)
*  **HOST_HOSTNAME** — FQDN jail
*  **PATH** — root filesystem for jail
*  **STATUS** — On (running), Off (stoped), Unregister (jail has its rc.conf (old format) but not in the SQL database)

Note: Jail in the unregister status may be insert to SQL database via command: cbsd jregister. Also, they are automatically converted on Upgrading stage of cbsd initenv command. In a case when to the local server are added a key of remote of nodes, it is possible to receive the list of all jails in a farm via


```
cbsd jls alljails=1
```
or

```
cbsd jls alljails=1 shownode=1
```
for output with node name where jail are hosted. In the output from cbsd jls alljails, it is possible to see only active jails (in status On)

**Example:**

```
% cbsd jls
```

![](img/jls1.png)

Conclusion customized data (Attention, dashes fields may mean that version of **CBSD** on the remote node is older. Respectively, SQL query in its database does not find relevant records)

![](img/jls2.png)
