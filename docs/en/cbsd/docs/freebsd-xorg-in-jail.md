# FreeBSD: Xorg in jail

##Introduction

Traditionally, it is assumed that FreeBSD — decent choice as a server OS, but on the role as a modern workstation suitable weak. Apologists and just hotheads on both sides of this opinion give different pros and cons and this article is not about this stupid dispute. Instead, there will also attempt to relate and fantasize about seemingly completely different technologies, such as Xorg and Jail, and demonstrated one of the scenarios with FreeBSD as a workstation.

Not so rare on the Internet you can find information about what additional properties from the *nix system acquires user running Xorg-based application [chroot(8)](http://www.freebsd.org/cgi/man.cgi?query=chroot&sektion=8).

There may be many reasons, one of them — you like to experiment with different numbers of environments and do not really want to convert the file system in the trash (and possibly receive conflicts between one or another application on the file system.)

Also, do not last role security. No one can guarantee that any installed software, whether **skype, mc, screen, firefox** and so, at the first update, due to an unfortunate typo in the code will scan randomly your home directory for **id_rsa** keys and **known_hosts, .mysql_history, .bash_history** and all your settings from an account `~/.local, ~/.config , ~/.kde4`and send them to the developer’s website as necessary for further development of software updates statistics. Thus, chroot allows in this case to keep your eggs in one basket, which in itself — perfect.

If **chroot** deal with it, one might ask — «what can give jail startup it Xorg». Chances are, if you know the differences between jail and chroot and since you are reading this article, the answer is found and you can proceed to the next chapter. If not, then:

The main difference in this respect from jail chroot, a grouping of processes by ID (**jid**), which may participate in certain activities as an audit only for these processes, the ability to gather statistics through RACCT, setting limits through [rctl(8)](http://www.freebsd.org/cgi/man.cgi?query=rctl&sektion=8) (useful for profiling applications). And, of course, binding network addresses, the ability to stack isolated and separate routing tables for all jailed processes.

The remaining additional advantages can already provide specific jail management utility. So, what can you get from X-jail, depends on your knowledge and imagination, and **FreeBSD** as usual, playing only a tool for the task.

Bring their own particular cases that receives and uses the author.

In the case of **CBSD/jail/FreeBSD**, an opportunity to:

* downloaded from the repository environment preconfigured with various embodiments of the popular Windows Manager: **KDE4, Fluxbox, Gnome3, LXDE** and so on;
* convenient option to export and import the image;
* repciation via **zrep** for incremental backup;
* opportunity to apply file snapshots;
* opportunity to using [cpuset(1)](http://www.freebsd.org/cgi/man.cgi?query=cpuset&sektion=1) to bind all X applications on a specific core or core group;
* You can use different limits for the entire cell, whereas the chroot, you can apply through the limits [limit(1)](http://www.freebsd.org/cgi/man.cgi?query=limit&sektion=1) only user or PID, which is not so convenient.
* In the case of chroot and having multiple IP alias-s in the system as a source ip for a connection, the application will always use the first IP. In the case of jail and having multiple IP, you can restrict the IP for applications to only those that you need. In this case you can use PF/IPFW to calculate the X-traffic applications emulate the «bad» network, adding delay or loss on the net this jail, playing with traffic bandwith, etc. to study the work of an application under different conditions.
* If you have multiple workstations via jail you can make a «floating» environment in a simpler way: for any station you would not be, you are always in the same environment, all history, all received email, even if it was adopted with the work station to another — always with you. You do not need to update the software directly in 3 systems if you ispoluete 3 working system and a set of software changes.

## What is required for X-jail

To Xorg worked successfully in jail, it is necessary to remove the restrictions jailed processes to access `/dev/io` and `/dev/kmem` devices. Already [long time](http://www.leidinger.net/blog/2007/04/07/a-desktop-environment-in-a-jail/) there are patches of Alexander Leidinger aka [netchild](http://www.leidinger.net/), optionality that provide these settings. And now, as far as I know, Jammie Gritton [gave a jolt to the discussion](http://lists.freebsd.org/pipermail/svn-src-head/2014-January/055578.html) the possible inclusion of patches in one form or another in the base. You can apply the patch and recompile your kernel yourself, or you can use the command:

```
% cbsd repo action=get sources=kernel
```
And get a kernel with patches applied from the repository **CBSD**.

```
**Attention**: Due to resource limitations, this patch is applied only for the FreeBSD kernel 11 aka HEAD (as of this writing) in the repository **CBSD**
```

```
**Attention**: **allow_kmem** option violates the concept of jail security and should be used for containerization ONLY YOUR X-jails. Do not enable this feature in the jail that have the potential attackers access.

```

In the presence of these patches, configuration **CBSD** jail will have the option allow_kmem**, which can be set through cbsd jset or **cbsd jconfig**

In addition, you may need to add a separate rule for [devfs.ruleset(5)](http://www.freebsd.org/cgi/man.cgi?query=devfs.ruleset&sektion=5), appropriate devices to become visible in the `/dev` directory in jail. For example this content:

```
[devfsrules_unhide_xorg=8]
add include $devfsrules_hide_all
add include $devfsrules_unhide_basic
add include $devfsrules_unhide_login
add path agpgart unhide
add path console unhide
add path consolectl unhide
add path dri unhide
add path 'dri/*' unhide
add path io unhide
add path 'nvidia*' unhide
add path sysmouse unhide
add path mem unhide
add path pci unhide
add path tty unhide
add path ttyv0 unhide
add path ttyv1 unhide
add path ttyv8 unhide

```

and specify the appropriate number **8** in **devfs_ruleset** parameter from jail config.

The configuration is completed and further work on the launch of Xorg in jail is no different from the usual steps:

* Install software
* Generate `/etc/X11/xorg.conf` (if necessary) and create `~/.xinitrc`
* Run X


```
**Attention**: allow_kmem option violates the concept of jail security and should be used for containerization ONLY YOUR X-jails. Do not enable this feature in the jail that have the potential attackers access.
```
[Short demo of XJail from scratch.](http://youtu.be/YcfmRnxHRKY)

## Full Example Step-by-Step: KDE4 in xjail with NVIDIA GL

For Radeon/Intel graphics user steps are the same, except for installation of nvidia-settings, nvidia-driver and `/usr/src`

Initial state - installed from scratch FreeBSD, without ports and source tree system

1) Install **CBSD** and init workdir:

```
% pkg install cbsd
% env workdir="/usr/jails" /usr/local/cbsd/sudoexec/initenv
% service cbsdd start
```
2) We need a mouse, turn the service **moused**:

```
% sysrc moused_enable="YES"
```
3) Create jail with **kde4** name. In submenu **pkglist** choose MANUAL and write what software we need in a jail: **x11/xorg x11/kde4**:
The rest of the software and settings - at your discretion.

4) We need a kernel with patches. You can build your own for instructions FreeBSD maillist or receive from **CBSD** repository:

```
% cbsd repo action=get sources=kernel
```

5) Install new kernel into `/boot/kernel`:

```
% cbsd upgrade target=kernel
```

6) Reboot system to new kernel:

```
% shutdown -r now
```
7) In the settings jail solve **allow_kmem** and change **devfs_ruleset** any non-existent (for example **99**). In this case, will be open all `/dev`. If you all to open inappropriately - use the information above to create your **ruleset**:

```
% cbsd jstop kde4
% cbsd jset jname=kde4 allow_kmem=1
% cbsd jset jname=kde4 devfs_ruleset=99
```

 other than that (only for NVIDIA users) ask **CBSD** to mount `/usr/src` in jail. It is necessary to build **nvidia-driver** port (from which the need **libGL.so** in environment)

 ```
 % cbsd jset jname=kde4 mount_src=1
 ```
Instead **jset** You can use the TUI configurator: **cbsd jconfig jname=kde4**

8) Only for NVIDIA users: we need a source tree `/usr/src` to build `x11/nvidia-drivers`
To do this, fill `/usr/src` and `/usr/ports` relevant content. Or, you can ask it to do **CBSD**
For receive `/usr/ports` from **SVN FreeBSD**:

```
% cbsd portsup
```
For receive `$workdir/src/src\*` (which we will create a symlink to not keep two copies) from **SVN FreeBSD**:

```
% cbsd srcup
% rmdir /usr/src ( or, on ZFS installation, remove pseudo-fs: <strong>zfs destroy zroot/usr/src</strong> )
% ln -sf ~cbsd/src/src_10.1/src /usr/src
```
(If the version of FreeBSD does not 10.1, the path will be different)

9) Only for NVIDIA users: install dependencies **nvidia-driver** repository of the installation and removal **nvidia-driver**. In addition, we need **glprotoi**

```
% pkg install x11/glproto x11/nvidia-driver
% pkg remove nvidia-driver
```

10) Only for NVIDIA users: Install the NVIDIA driver from ports:

```
env BATCH=no make -C /usr/ports/x11/nvidia-driver install
```

11) Only for NVIDIA users: prescribes module **nvidia.ko** in autoload, increase **ipc.shmall** as advised by the port:

```
% sysrc kld_list="nvidia"
% echo "kern.ipc.shmall=1310720" >> /etc/sysctl.conf
```
11) The same actions, but for users with **Intel** graphics: just add into `/boot/loader.conf`:

```
hw.vga.textmode=1
drm_load="YES"
drm2_load="YES"
i915kms_load="YES"
```
12) Restarting the server (or load modules manually), run and prepare jail:

```
% shutdown -r now
% cbsd jstart kde4
% cbsd jlogin kde4
```

13) Subsequent steps are performed in the environment. Inside the jail expose dbus to autostart

```
% sysrc dbus_enable="YES"
% service dbus start
```
14) Install **nvidia-driver** into jail by analogy with paragraph **9** and **10**

```
% pkg install x11/glproto x11/nvidia-driver
% pkg remove nvidia-driver
% env BATCH=no make -C /usr/ports/x11/nvidia-driver install
```
15) If you do not know how to write still working **xorg.conf** from scrath, better to generate it via **nvidia-xconfig**:

```
% pkg install x11/nvidia-xconfig
% nvidia-xconfig
```
Users with Intel can take advantage with X staff:

```
% X -configure
```
And copy the generated `/root/xorg.conf.new` in `/etc/X11/xorg.conf`
Append in the generated `/etc/X11/xorg.conf` the **ServerFlags** section:

```

Section "ServerFlags"
       Option         "AutoAddDevices" "off"
       Option         "AutoEnableDevices" "off"
       Option         "AllowEmptyInput" "off"
EndSection
```
16) Create a user xuser, if you have not done so when creating jail:

```
% pw useradd xuser -m -s /bin/csh
```
17) Go to the user, write standard `~/.xinitrc` and run KDE:

```
% su - xuser
% echo startkde >> ~/.xinitrc
% xinit
```

It may be useful to make additional settings

18) Mount Linux-specific FS, for normal Linux-applications in the jail. To do this, the master node to create a local fstab to jail with this content:

```
file `/usr/jails/jails-fstab/fstab.kde4.local`

	linprocfs       /usr/compat/linux/proc  linprocfs       rw      0       0
```
19) If you plan to synchronize the jail to another server and periodically run on another node, and the configuration of the second node is different, it is best to save the xorg.conf in the master node and create a script that will copy it every once in to `/etc/X11/` in the jail. The same must be done for the other node

It is done in the master node

```
% cp /usr/jails/jails-data/kde4-data/etc/X11/xorg.conf /etc/X11
```
In `/usr/jails/jails-system/kde4/master_poststart.d` directory create new script **xorg.sh** with such content:

```
#!/bin/sh
cp -a /etc/X11/xorg.conf ${data}/etc/X11/xorg.conf
```

Make script executable:

```
% chmod +x /usr/jails/jails-system/kde4/master_poststart.d/xorg.sh
```
You can also do with /etc/resolv.conf and /etc/hosts if necessary
