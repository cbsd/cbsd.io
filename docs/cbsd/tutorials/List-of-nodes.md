# List of nodes

**node mode=list command**

```
% cbsd node mode=list
```
The command **cbsd node mode=list** show name of the nodes RSA which keys were received through cbsd node add. Too most it is possible to receive, having seen the catalog `$workdir/.rssh`, in which there are keys.

Through argument display you can specify the fields for output data. If display is not specified, the value takes from `$workdir/etc/defaults/node.conf` file, which you can change at its discretion via `$workdir/etc/node.conf`

**Example:**

```
% cbsd node mode=list
```

![](img/nodelist1.png)
