# Jail settings

Each jail managed by  cbsd has its own settings which are used when starting and stopping the jail. Some of them are specified during the creation of the jail, can be set with the command

```
% cbsd jconfig jname=jname
```

Currently only few options be changed on-the-fly.
This page contains a summary of the default settings and description.

```
jname="jail1";
```
First, the unique name of the jail. This is needs to be identical with the name shown by **cbsd jls** or in the inventory list. This field can not be changed manually. If you want to change the name of the jail please use **cbsd jrename**, because the name of the jail is used in many other configs and directory names

```
path="/usr/jails/jails/jail1";
```

Indicates the path that will be used as  root at  when the jail is run. The above configuration is characteristic of jails who are setting baserw to 0 (no write access in base), ie, the base of which is mounted in read-only. In this case, the algorithm will work jstart follows:


  +  1) mount a base via nullfs specific version (see below) to `/usr/jails/jails/$jname` directory
  +  2) on the mounted base at `$workdir/jails/jails/$jname` mount directories related directly to the jail data (in the directory `$workdir/jails-data/$jname`), usually in write access
  +  3) start jail with the root `$workdir/jails/jails/$jname`

If baserw=1, then nullfs not use and the jail immediately starts with the directory `$workdir/jails-data/$jname` as root. In these cases, the path is usually seen as a *path="/usr/jails/jails-data/jail1-data"*;

```
host_hostname="jail1.my.domain";
```

FQDN, the full name of the jail. This field can not be changed manually. If you want to change the name of the jail please use **cbsd jrename** command

```
ip4_addr="10.0.0.5/24";
```

IP address of the jail. If you plan to use multiple IP addresses, they are separated by commas:
ip4_addr="10.0.0.5/24,192.168.0.2/30,54:04:a6:b2:11:c4/64«;

```
mount_devfs="1";
```

Mount a devfs file system into the jail (directory /dev). Most services without this simply can not work.

```
allow_mount="1";
```
Allow users or services mount other file system inside the jail

```
allow_devfs="0";
```
Allow users or services mount devfs file system inside the jail

```
allow_nullfs="0";
```

Allow users or services mount nullfs file system inside the jail

```
mount_fstab="/usr/jails/jails-fstab/fstab.jail1";
```

The path to a file containing a list of directories or file systems to be mounted with the jail when it is run

```
arch="amd64";
```

Jail architecture (and respectively base from the `$workdir/basejail`)

```
mkhostsfile="1";
```

Whether correct in jail `/etc/hosts` entry

$ip4_add $jname $jname.my.domain

in accordance with the IP address and the name (FQDN) of jail

```
devfs_ruleset="4";
```
a set of rules devfs, which will be applied to the devfs file system in the /dev of jail (list of rules in the file `/etc/devfs.rule`s of master node)

```
interface="auto";
```
This recording controls the behavior of the automatic creation and deletion of IP addresses on the interface or use the previously established.

The value **auto** means that cbsd will select the interface on which to create an IP address jail.

For example : there is a node with two interfaces .

At the interface igb0 set IP subnet 10.0.0.2/24 and while the default gateway for the server is 10.0.0.1, in consequence of which igb0 a network card, through which the traffic by default. at the interface igb1 registered IP/subnet 192.168.0.1/24.

If the jail in rc.conf ip4_addr takes value 192.168.0.{1-255}, then **CBSD** automatically selects igb1 interface for IP jail.

If none of the interface is not the subnet that contains the IP jail will be selected by default interface.

Also, the value can be set to the name of the interface, if you do not want to search for a suitable interface. For example record

```
interface = «igb0»
```

sets the IP address of the jail at the interface igb0.

As well as during start-up, when **CBSD** will sets the necessary IP for jail on interface, when you stop them **CBSD** unset IPs from the interface automatically. Therefore, be extremely careful — If you set by mistake IP address of the node for jail , then, during the cbsd jstop sequence, **CBSD** execute

```
ifconfig <iface> <ip> -alias
```

and a node will be lost in the network.

To the stop of management IP address, the interface= param can be commented out or removed, or the value is left blank:

```
interface=""
```
In this case, **CBSD** will immediately start the jail with the appropriate IP, meaning that he has already been initialized . Such a situation may be necessary when server has only one IP address, and you plan to run jail ( or a few jails ) in one existing IP, but with the services within that do not conflict the ports.

For example, having one IP address , you can start jail with WEB server on port 80 , another jail with the mail server on port 25 and so on.

```
ver="10.0";
```

Version of the base for jail. Is directly related to the version of FreeBSD. Thus, if the jail are have in rc.conf options

```
arch="amd64"
ver="10.0"
baserw=0
```

then at the start of the jail `${workdir}/basejail/base_amd64_10.0` will be selected. When

```
arch="i386"
ver="9.1"
baserw=0
```

it will accordingly be used `${workdir}/basejail/base_i386_9.1.`

This way you can switch the version of base from one version to another

When baserw=1 means that the entire base has been initialized and is filled from `${workdir}/jails-data/$jname-data`, so that these parameters do not matter

```
basename="";
```

The base name. You can create a customized base, for example to build a minimal environment and place it to `$workdir/base_lite_amd64_9.2`

To specify CBSD that you need to mount this directory, basename must have «lite» prefix:

```
basename="lite";
```

```
baserw="0";
```

When 1, it is understood that a jail has its own base file system and has an entry. Typically, this parameter is set during the creation of the jail. If you originally created the jail with baserw=0 (readonly), but want to switch it into a baserw=1 mode, you first need to copy all the files from the base directory to $workdir/jails-data/$jname-data. For example:

```
cd /usr/jails/basejail/base_amd64_10/
pax -p eme -X -rw . /usr/jails/jails-data/jail1-data
```
or, if you have in the master node object files:

```
make -C /usr/src installworld DESTDIR="/usr/jails/jails-data/jail1-data"
```
In the same way, at this stage, it is supposed to update the jail that operate in baserw=1, since each cell has a personal copy of the base.

In contrast, when using baserw=0, you can only use one copy of the base, which is mounted through nullfs in read-only to all jails.

In addition, with baserw=0 you have the opportunity to update the version of the base less.

In addition, the base is mounted in read-only mode gives you extra security if your jail hacked and somebody try to modify the file system — this is simply will not work.

```
mount_src="0";
```

Does the mount /usr/src directory of jail FreeBSD source code in read-only, if they have

```
mount_obj="";
```

Does the mount /usr/obj directory of jail FreeBSD source code in read-only, if they have

```
mount_kernel="0";
```

Does the mount /boot/kernel kernel FreeBSD. This can be useful, for example, for CTF-information required to operate DTRACE.

```
mount_ports="1";
```
Does the mount /usr/ports of the master node in readonly to /usr/ports in jail. You can have one copy of ports tree on the master node that is deployed in /usr/ports, and which mount to all jails. In order to simultaneously compilation of the same port are not conflicted in two or more jails, in the `/etc/make.conf` option WRKDIRPREFIX must be sets to for alternate location, such as /tmp (if the jail has applytpl=1 settings, this is done automatically)

```
astart="1";
```
Whether to start jail automatically when nodes is started. If astart=0, the jail does not run itself on booted node.

```
vnet="0";

```
```
applytpl="1";
```

Whether to apply some modification in the jail configuration: sets pkg.conf, make entries in the /etc/hosts, and so on.

```
mdsize="0";
```

```
rcconf="/usr/jails/jails-rcconf/rc.conf_jail1";
```

```
floatresolv="1";
```

Automatically correct the /etc/resolv.conf, automatically assigning as the primary nameserver caching named in the master node, the other nameserver — from inventory of nodes.

```
exec_start="/bin/sh /etc/rc";
exec_stop="/bin/sh /etc/rc.shutdown";
```
System commands for starts and stops jail. If you want to write additional scripts executed by starting and stopping jails see: [Jail config](../tutorials/jail-config.md)

```
cpuset="0";
```
Assign jail and its processes to specific cores CPU. A value of 0 (default) means that there is no binding to CPUs and processes will take up all the available cores. Nonzero value identifies the kernel or a list of the CPUs allowed to work jail. Entry must match an entry form for -l cpu-list from [cpuset(1)](http://www.freebsd.org/cgi/man.cgi?query=cpuset&sektion=1) command, for example:

```
cpuset="1";
```

means that the processes will only run on first core

```
cpuset="0-3"
```
means that the processes will only run on first core

```
cpuset="0,3"
```
means that the process will only run on 0 and 3 CPUs
This functionality is useful, for example, for profiling software, or if you want to restrict jails by CPUs.

```
setfib="0";
```

Assign jail and its processes to separate routing table. A value of 0 (default) means that there is no binding and will be use default routing table. To use setfib, in the file /boot/loader.conf you need to set limits number of tables by parameter net.fibs. For example, if you want use five separate routing tables, in /boot/loader.conf you must have the following entry:

```
net.fibs="5"
```

```
exec.consolelog="0";
```

Regulates logging output of jail(8) at the start and stop of the jail. By default, the value is **0**.

Possible values are:


   + **0** — disable exec.consolelog. In this case, on jstart/jstop will show all output for jail start and jail stop procedures.

   + **1** — Enable logging to file `${workdir}/var/log/${jname}.log`, where $jname — an appropriate name if jail. Thus, the terminal these messages will not.

**/path/to/file** — Path to alternate file. For example, with **/dev/null**, the jail will not show anything and it will not record.
