# Other methods of creating jail

**jcreate command, part 2**

**Description:**

If DIALOG-based script jconstruct-tui for some reason did not come for create configuration of the new jails, you can use the script, dialogue like "question and answer" **jconstruct**

```
% cbsd jconstruct
```

Which specifies the same question as the tui-version. Also, the configuration can avoid the formation without additional interactive utilities, for example building systems that automatically create the necessary jails.

Example of a standard configuration for **jcreate** might look like:

```
jname="jail1";
path="/usr/jails/jails/jail1";
host_hostname="jail1.my.domain";
ip4_addr="10.0.0.24/24";
mount_devfs="1";
allow_mount="1";
allow_devfs="0";
allow_nullfs="0";
mount_fstab="/usr/jails/jails-fstab/fstab.jail1";
arch="amd64";
mkhostsfile="1";
devfs_ruleset="4";
ver="10.0";
basename="";
slavenode="0";
baserw="0";
basename="";
mount_src="0";
mount_obj="";
mount_kernel="0";
mount_ports="1";
astart="1";
data="/usr/jails/jails-data/jail1-data";
vnet="0";
applytpl="1";
mdsize="0";
rcconf="/usr/jails/jails-rcconf/rc.conf_jail1";
floatresolv="1";
exec_start="/bin/sh /etc/rc";
exec_stop="/bin/sh /etc/rc.shutdown";

exec_poststart="0";
exec_poststop="0";
exec_prestart="0";
exec_prestop="0";

exec_master_poststart="0";
exec_master_poststop="0";
exec_master_prestart="0";
exec_master_prestop="0";
interface="auto";
jailskeldir="${sharedir}/jail-skel"
```

```
*** Note parameters arch and ver. Values of them may be "i386", "amd64" for arch and "9.2", "10.0", "10.1" "11" and so on, depending on the version of the base, which would you prefer for jail. Values native in these parameters force CBSD always take the version and architecture that is running the node, which makes the floating version. So, if you use a template with arch="native", ver="native" and switch from FreeBSD 10.2 to 11.0, it will use the 11.0 version of the base. If you want to fix a specific version - specify version instead native.
```

If you want to create jail with installed some packages from **pkg** repository, in this configuration must have an **pkglist** pointing to a file with a list of packages, for example:

```
pkglist="/tmp/newjail.txt";
```
The `/tmp/newjail.txt` file might look like:

```
mc
lynx
nginx-devel
lsof
```

**cbsd jcreate** remove file pointed by **pkglist** variables after jail create

```
*** Important: ***

When a new jail is created or obtaining from the repository, make it a rule ALWAYS change the user's password root in jail, even if you do not plan to run it ssh/ftp/rsh and similar services. If the jail is created with applytpl=0, by default /etc/{passwd,master.passwd,group} in the jail as the original "clean" files FreeBSD, so password of root user is empty. If jail created with applytpl=1 (it also refers to images from repository) $workdir/share/jail-skel files will be used as templates where root password is 'cbsd' in default CBSD installation. You can change default root password when new jail is created via edit of hash in skel master.passwd via:

% vipw -d ${workdir}/share/jail-skel/etc

commands, or specify alternative path to jail-skel dir in .jconf (jcreate tools) config
```
By default, the directory specified by **jailskeldir** will be used as source files that will be added (or they will be overwritten with standard files) into a jail automatically when applytpl=1. Accordingly, you can create any configuration templates and content environments that will be copied when creating a new jail.

