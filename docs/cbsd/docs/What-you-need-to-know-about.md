# What you need to know about CBSD
### General information

CBSD is an additional layer of abstraction for the [jail(8)](https://www.freebsd.org/cgi/man.cgi?query=jail&sektion=8) framework, and provides additional functionality not currently available in FreeBSD. It is collection of tools simplifying the work with jails scripts, and will work on any hardware that runs FreeBSD.

The additional functionality CBSD provides uses the following:

   * [vnet (VIMAGE)](https://www.freebsd.org/cgi/man.cgi?query=vnet&sektion=9)
   * [zfs](https://www.freebsd.org/doc/handbook/zfs.html)
   * [racct/rctl](https://www.freebsd.org/cgi/man.cgi?query=rctl&sektion=8)
   * [pf/ipfw/ipfilter](https://www.freebsd.org/doc/handbook/firewalls-pf.html)
   * [carp](https://www.freebsd.org/doc/handbook/carp.html)
   * [hastd](https://www.freebsd.org/cgi/man.cgi?query=hastd&sektion=8)
   * [bhyve](https://www.freebsd.org/doc/handbook/virtualization-host-bhyve.html)

While many of these subsystems are not directly related to jails, CBSD uses these components to provide system administrators a more advanced, integrated system in which to implement solutions for modern issues encountered in today's systems.
This page will provide information to help system administrators familiarize themselves with CBSD. While this page is not intended to be a comprehensive all encompassing how-to, it will provide details about where files are stored and how to use CBSD to manage and interact with the virtual environment.

The information provided here assumes a basic understanding of jails, how they are used, and how they are managed in FreeBSD. The official documentation about jails is a highly recommended starting point, and can be found in Chapter 14 of the FreeBSD Handbook: [Jails](https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/jails.html). The [jail(8)](https://www.freebsd.org/cgi/man.cgi?query=jail&sektion=8) manpage is also a great resource.

Before getting started, be aware of the following terminology, and how it will be used:

   + **Node**: A physical server that hosts the virtual environment.
   + **Jail**: An isolated environment, complete with its own set of software and services. A jail is able to run any software that is available to the OS installed in the jail (cli or graphical).
   + **Cloud**: A farm/cluster of interconnected nodes, or a full-fledged peer network (each node can do other tasks through CBSD)
   + **Base**: In the context of CBSD, a copy of the files in the FreeBSD base.
   + **CBSD**: An entity that has control over the specified node(s) and certain subsystems of FreeBSD. CBSD provides a unified way to interact with and perform actions on the specified nodes or jails via the provided API. CBSD also provides the ability to implement and use ACL, and change permissions on specified resources.
   + **$workdir**: The working directory on a CBSD node that is initialized via the cbsd initenv command on the initial run. This directory is /usr/jails unless otherwise specified.
   + **$jname**: The name of a jail in the CBSD environment.

### A quick word about jails. 
As stated, almost any software available to the OS that runs the jail can be ran inside of a jail. Server-side components such as DNS, Apache/nginx, or postfix, can run isolated from the host. Perhaps lesser known is hat graphical environments/applications can also run inside a jail isolated from the host. For example, run an XServer or VNCServer, then connect to it. A single application can be run from inside a jail, and then connected to using Xforwarding. `firefox -display=REMOTEADDR:PORT` There is also xjails, Xorg running inside a jail isolated from the host.

### Structure

CBSD uses the standard directories specified by jail(8). This allows jails to migrated to or from any other jail management system that also follows the standards set by jail. The goal for the directories where jails are stored is to be consistent, and adhere to the jail standards. This allows for the greatest compatibility.

The largest directory used by CBSD is where all of the data CBSD uses is stored. This is the directory `$workdir`, and is a symlink to `/usr/jails`by default. This directory can be changed when necessary. `$workdir` is also the CBSD user's home directory. To quickly enter this dir from any other path, pass `~cbsd` to the cd command.
```
% cd ~cbsd
```

There are two main directories used to store jail data. The deciding factor for which directory is used depends on whether or not a newly created jail should be able to write to it's base or not. This option is specified by passing the flag `baserw=0` or `baserw=1` when creating a new jail.

 `baserw=0;`

To create a jail with a read-only base, pass the flag `baserw=0`. Instead of writing to the base, the new jail will use the standard base from `$workdir/basejail/$basename`. Jails with a read-only base are stored in the directory `$workdir/jails/$jname`. Any `baserw=0` jail will mount the `$basename `through nullfs. This allows for the easy upgrade of all `baserw=0 `jails, as upgrading the `$basename `jail upgrades all of the jails using it. Another advantage is the fact that if a read-only jail is compromised, the attacker will be unable to modify anything in base as it is read-only.

`baserw=1`; When a new jail is created with the flag ` baserw=1`, the jail will have the ability to write to it's own base. Jails with this ability store data in the directory `$workdir/jails-data/$jname`.

Note: When using the jail type md, the directory `$workdir/jails-data/$jname`will contain the image of the jail.

Note: When using ZFS, CBSD has the ability to unmount a jail's data directory while the the jail is inactive. If a jail's data directory is found to be empty, don't panic. (At least when the jail is inactive). Check the output of the command;

```
% zfs list
```
To access the data use;

```
% zfs mount $jname_file_system
```

The second-largest directory in the CBSD hierarchy is `$workdir/var/db/`. This directory is where the configuration files for all of the jails created are stored. All jail settings are stored in the jails table in an SQLite3 database. The symbolic link `${workdir}/var/db/local.sqlite should` always points to the correct/current database. The table schema is described in the file `${workdir}/share/local-jails.schema`. SQLite3 can be used to query information about all jails on a node.
For example, to see all jails on the node, and their IP address' execute;

```
% sqlite3 /usr/jails/var/db/local.sqlite "select jname,ip4_addr from jails"
```

The `$workdir/jails-system/` directory serves as additional storage for CBSD jail data.
For example: There may be configurator's services, files with the description of the jails, traffic statistics, resources statistics, and so on.
Internal information for CBSD is stored in the `$workdir/db` directory.
For example: The information on the list of added nodes, inventory of both the local and remote nodes, and so on.

One important thing to note in regards to security are the directories `${workdir}/.rssh` and `${workdir}/.ssh`. These dirs contain the private RSA keys for the remote user CBSD nodes (.rssh) and the local nodes(.ssh). Make sure that the data in these directories are not available to other users of the system. For more information, please see the article about [GELI](cbsd-geli.md) encryption. By default, the key can be read only by a system CBSD user.
Finally, be sure to read about the modifications that CBSD does to the system. This [page](modification-cbsd-scrips.md) describes all of the modifications that are carried out by CBSD scripts after installing on a FreeBSD system.

### Multiple operation by jname as mask

Most of the CBSD commands are support jname as mask.

For example, if you want to perform a similar operation on a group of jails (e.g: jail1, jail2, jail3), you can use **jname='jail*'**

Another example:

```
cbsd jset jname='*' ver=native
cbsd jset jname='*' ver=native astart=0 devfs_ruleset=4   [..]
cbsd jexec jname='jail*' file -s /bin/sh
cbsd pkg jname='myja*l*' mode=install  ca_root_nss nss
cbsd jstop jname='*'
cbsd jstart jname='lala*'
```

![example](gif/jnamemask.gif)

### A brief summary of the filesystem hierarchy in CBSD

| Option | Description |
|:------| :-----------|
|${workdir}/.rssh/| This directory stores the private keys of remote nodes. The files are added and removed via the command **cbsd node**|
|${workdir}/.ssh | This directory stores the private and public keys of the nodes. The directory is created during initialization with the command **cbsd initenv**. This is also where the public key comes from when the command **cbsd node mode=add** is issued to copy the public key to a remote host. The Key file name is the md5 sum of the nodename. |
|${workdir}/basejail | This directory is used to store the bases and kernels for FreeBSD that are used when creating **baserw=0** jails. These are generated via cbsd buildworld/buildkernel, cbsd installworld/installkernel, or cbsd repo action=get sources=base/kernel |
|${workdir}/etc | Configuration files needed to run **CBSD**|
|${workdir}/export| The default directory that will be stored in a file exported by the jail (a cbsd jexport jname=$jname, this directory will file $jname.img)|
|${workdir}/import| The default directory containing data to be imported to a jail (a cbsd jimport jname=$jname, will be deployed jail $jname)|
|${workdir}/jails | This directory contains the mount point for the root jails that use baserw=0. |
|${workdir}/jails-data | This directory stores all jail data. Backup these directories to take a backup of the jails (including fstab and rc.conf files). Note: if a jail uses baserw=1, these directories are the root of the jail when it starts. |
|${workdir}/jails-fstab | The fstab file for the jails. The syntax for regular FreeBSD with the only exception that the path to the mount point is written relative to the root jail (record **/usr/ports /usr/ports nullfs rw 0 0** in the file fstab.$jname means that of the master node directory /usr/ports will be mounted at startup in ${workdir}/jails/$jname/usr/ports) |
|${workdir}/jails-rcconf | rc.conf files for jail creation. These parameters can be changed using $editor, or via the command ***cbsd jset $jname param=val*** (eg cbsd jset jname=$jname ip="192.168.0.2/24"). To change these settings, the jail should be turned **off**. |
|${workdir}/jails-system |  This directory may contain some helper scripts related to the jail (eg wizards to configure, configurators, etc) as well as the preserved jail traffic when using ipfw and its description. This catalog participates in jimport/jexport operations and migration of jail |
|${workdir}/var |  This directory contains system information for **CBSD**. For example, in ${workdir}/var/db is an inventory of local and remote nodes that were added. |
|/usr/local/cbsd |  A copy of the original files installed by the **CBSD** port. The working scripts for sudoexec can also be found here. |


### Counting jail traffic


**CBSD** uses the count ruleset of **[ipfw](https://www.freebsd.org/doc/en/books/handbook/firewalls-ipfw.html)** filter to count jail traffic. **CBSD** sets the number of counters in the **99 — 2000** range. The range can be easily adjusted in cbsd.conf if this interfes with existing rules. Be mindful when changing firewall rules. **CBSD** "takes ownership" of the rules in the range given. In otherwords, if there are other rules already in place using the specified range, there is the posibility that **CBSD** could delete and re-add the rules in the range. This means all rules in the range would be deleted, but only the CBSD rules would be added back in.

Read more about [counting jail traffic](../tutorials/a-few-words-about-jail-traffic-counting.md).


### Expose: tcp/udp port forwarding from master host to jail


**CBSD** uses the **fwd** ruleset of **ipfw** to configure port forwarding. **CBSD** sets the number of counters in the **2001 - 2999** range. This range can easily be changed in cbsd.conf if need be. Again, always be mindful when changing firewall rules. Make sure no rules conflict with the range configrured for **CBSD** to use.

Read more about [expose](../tutorials/port-forwarding-for-jail.md).


### About rsync-based copying jail data between nodes


**CBSD** offers a wrapper to rsync called cbsdrsyncd. If **cbsdrsyncd** is activated, please keep in mind that there is a standard **rsyncd(1)** daemon running that looks at the specified *$jail-data* directory, and is protected by the rsync password. **CBSD** generates a strong password via the following command;

```
head -c 30 /dev/random | uuencode -m - | tail -n 2 | head -n1
```

**CBSD** transmits data through the rsync daemon over port 1873/tcp. Please secure this port from any traffic excpet for remote **CBSD**, or use encrypted communication between the nodes using something like IPSec.


### ANSII Color

**CBSD** displays output using colorized text by default using ANSII escape sequences. Doing so helps important information standout. If the colors are found to be unpleasant, or interfere with using output from commands or utilities available in **CBSD**, colors can be disabled by setting the environment variable NOCOLOR=1.
For example, issuing the command;

```
 % env NOCOLOR=1 cbsd jls
```

will disable the use of color in the output of the names of the jails.






### If something went wrong...

While the **CBSD** project strives to be bug free, like in any other software bugs can happen. If a component or tool that is part of **CBSD** crashes, or returns unexpected data or behaviour, a debuging command can be enabled: [**CBSD** command debuging](https://www.bsdstore.ru/en/cmdsyntax_cbsd.html#cmddebug). If the bug is reproducible, and an actaul bug discovered, please report the issue via e-mail: **CBSD @**(at) **bsdstore.ru**, or better yet submit a pull request that identifies the issue found, and contains the code to resolve the issue.

#### Taking backups of CBSD virtual environment.

 **Taking a backup**
Any sys admin worth their salt would agree that taking regular backups is a must to ensure data is safe. To properly backup the virtual environments on the node, the following directories must be included (The description of each of these directories is in the table above;


- ${workdir}/var/db
- ${workdir}/jails-fstab
- ${workdir}/jails-system
- ${workdir}/jails-data
