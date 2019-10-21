# Starting and stoping jail

## jstart, jrestart, jorder commands

```
% cbsd jstart jname=jail1 jail2
% cbsd jstart jail1 jail2 ... jailX

% cbsd jstop jname=jail1 jail2
% cbsd jstop jail1 jail2 ... jailX

% cbsd jrestart
% cbsd jorder
```

**Description:**

Running jails occurs at startup **CBSD/server** automatically if parameter **astart** (auto-start) corresponding jail set to 1. You can change this setting through **cbsd jconfig** or **cbsd jset**. When you stop the server or service **cbsdd**, all running jails will be stopped automatically.

Starting the jail manually by the command:

```
% cbsd jstart jname=jail1
```
or

```
% cbsd jstart jail1
```

or

```
% cbsd jstart jail1 jail2 jail3 ..
```

to launch multiple jails by one command)

When ( You can change this behavior in cbsd initenv-tui ) **parallel=0** and you try to launch/stoping a few jails, start/stop will be held consecutively. It is not always good, as any error triggered inside jails in the rc-scripts, which leads to a pause, can block start/stop next jails. In the case when **parallel** have a non-zero value, each next jails will be launched/stopped in N seconds after the previous one, where N — **parallel** value. After this timeout, no matter whether the previous jail o start fully and next jail will be started.

To stoping jail **jstop** must be used, with the same syntax and behavior:

```
% cbsd jstop jname=jail1
```
or

```
% cbsd jstop jail1
```
or

```
% cbsd jstop jail1 jail2 jail3 ..
```

(to stopping multiple jails by one command)

If the argument of the jstart/jstop/jrestart command is missing, will displays the corresponding list of all running or stopped jail for interactive selection

When the jail is started, it creates a lock file, a sign that the jail working via file `${jailsysdir}/${jname}/locked` which records the name of the node. This feature is used when this jail presented several nodes, these jail are in the DFS (NFS, glusterfs, etc.) and any node is able to run it. This lock ensures that the presence of the same jail at the second node, it will not be launched.

With a large number of jails (particularly databases, with services such as MySQL, redis, cassandra, etc.), it should be borne in mind that the low value **parallel** (for example, less than 5 seconds) can generate a very intensive storage I/O load that can increase the amount of start-up time of all jails, than if they were run sequentially or higher timeout.

Additionally, when a shutdown command is running on the server with lots of jails/services that should be taken into consideration low timeout that defaults to perform rc.shutdown sequence. In this regard, the process init(8) can interrupt the rc-scripts on this timeout, resulting in abnormal shutdown jails. In this case, the database can lead to nonconservation or damage data. To avoid this, **/etc/rc.conf** master system should be adjusted parameter **rcshutdown_timeout** to a more reasonable value (default: 90 seconds)

In the absence of rcshutdown_timeout in the system /etc/rc.conf, cbsd initenv will put this option in its sole discretion automatically.

Also, keep in mind that when using the zfs features (`$workdir/nc.inventory`, the parameter **zfsfeat=1**), and the file system ZFS, at jstop, file system of jails will be unmounted and those catalog `$workdir/jails-data/jail1-data` will be empty. If in such a case when jail data is requires without running it, by the command **zfs list** You can see the name appropriate file system and run zfs mount **fs**.

![](gif/jstart.gif)

