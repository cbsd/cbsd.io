# Jails snapshot (zfs-only)

**jsnapshot command**

```
% cbsd jsnapshot
```

**Description:**

A variety of operations on jails become available through jsnapshot when the node is kept on a ZFS filesystem and **zfsfeat** is set to 1 in `$workdir/nc.inventory`. The **mode** parameter is used to specify which of the following actions are taken:

*  **list** — show a list of existing snapshots for the selected jail
*  **create** — create a snapshot
*  **destroy** — delete a specific snapshot of the jail
*  **destroyall** — remove all of the jail's snapshots
*  **clone** — clone an existing snapshot into new jail
*  **rollback** — rollback the selected jail to current snapshot state

Additional arguments:

*    **jname** — specifies the jail upon which the action will be performed
*    **snapname** — gives the snapshot a name

It should be kept in mind that snapshots follow a tree structure. This means, if you created a series of snapshots : **1,2,3,4** and roll back to snapshot **2**, then the snapshots **3** and **4** will be lost, since from the point of snapshot **2** they did not exist yet. Also use a unique name for a snapshot at creation. You can specify snapname=gettimeofday. In this case, the system automatically sets the current timestamp as the name for the new snapshot. When listing snapshots, you can use modifiers to customize output fields with arguments to **display=**

**Example:**

create snapshot named gromozeka for **jail1** jail:

```
% cbsd jsnapshot mode=create jname=jail1 snapname=gromozeka
```

create snapshot named zelepuka for **jail1** jail:

```
% cbsd jsnapshot mode=create jname=jail1 snapname=zelepuka
```

Run jail1 and stop after some modification:

```
% cbsd jstart jail1
..
% cbsd jexec jname=jail1 cp /bin/date /root
% cbsd jexec jname=jail1 file -s /root/date
/root/date: ELF 64-bit LSB executable, x86-64, version 1 (FreeBSD), dynamically linked (uses shared libs), for FreeBSD 9.0 (900506), stripped
% cbsd jstop jail1
..
```
Rollback jail1 to snapshot zelepuka state:

```
% cbsd jsnapshot mode=rollback snapname=zelepuka jname=jail1
% cbsd jstart jail1
...
% cbsd jexec jname=jail1 file -s /root/date
/root/date: ERROR: cannot open `/root/date' (No such file or directory)
```

![](img/jsnapshot1.png)

![](img/jsnapshot2.png)
