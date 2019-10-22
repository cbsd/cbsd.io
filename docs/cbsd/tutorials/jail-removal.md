# Jail removal

**jremove command**

```
% cbsd jremove
```
**Description**

Removal of jail mentions all files anyway connected with a jail:

    a) fstab for current jail
    b) data directory or ZFS filesystem with jail data
    c) statistics and description for jail
    d) snapshots

in a case when **jremove** executed for jail in status On, it will be automatically stopped.
**Example:**

```
% cbsd jremove jail1
```
![](img/jremove1.png)
