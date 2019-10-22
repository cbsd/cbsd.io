# bhyve virtual machine create via dialog menu

## Commands: bcreate, bconstruct-tui

```
% cbsd bconstruct-tui
% cbsd bcreate jconf=/path/to/conf.jconf
```

**Description:**

The virtual machine is created on a pre-formed configuration file through **cbsd bcreate jconf=path_to_cfg**.

For the configuration process, you can use the script **cbsd bconstruct-tui**, or use WEB interface.

To create a via DIALOG:

```
% cbsd bconstruct-tui
```

The same menu is available to create a jail when configuring **CBSD** via bsdconfig

![](img/cbsd_syntax3.png)

If **bconstruct-tui** worked correctly, at the end you will be asked to create a virtual machine. In the case of positive response, bcreate will be made to the new configuration automatically. Otherwise, script displays the path to the configuration file (in `$workdir/tmp`), on which you can create a VM.

![](gif/bcreate.gif)

## Virtual Machine Profiles

Profiles that come with CBSD and on which systems determine the URL from which the ISO image is downloaded, placed in the catalog ~workdir/etc/defaults/ and start with the prefix vm-
. For example, you can see the profiles list by command:

```
% ls -1 ~cbsd/etc/defaults | grep ^vm-
vm-dflybsd-x86-5.conf
vm-freebsd-FreeBSD-x64-11.1.conf
vm-freebsd-FreeBSD-x64-12.0-LATEST.conf
vm-freebsd-FreeNAS-x64-11.conf
vm-freebsd-pfSense-2-RELEASE-amd64.conf
vm-linux-CentOS-7.4-x86_64.conf
vm-linux-Debian-x86-9.conf
vm-linux-fedora-server-26-x86_64.conf
```
Since the **CBSD** releases come out much less often than the versions of the various distributions, these profiles may expire quickly enough, and as a result, the image becomes inaccessible by the old links.

In order not to get into similar situations and get new profiles, you can update them separately from **CBSD** with the Makefile in the `~workdir/etc` directory. There are two commands in the Makefile (you will see them if you just write make in this directory):

*  make profiles-create - is done once by starting the git repository from the GitHub: [https://github.com/cbsd/cbsd-vmprofiles](https://github.com/cbsd/cbsd-vmprofiles)
*  make profiles-update - is done every time (after profiles-create) when you want to update profiles

Since these operations are used by git, you must first install it in the system: pkg install devel/git (or from the ports: `make -C /usr/ports/devel/git install`)

For example:

```
% cd ~cbsd/etc
% make profiles-create
% make profiles-update
```
## Creating your own virtual machine profiles

 If your desired OS profile is missing from the **CBSD** distribution, or for some reason you are unsatisfied, you can create your profile by analogy with an existing one

Custom profiles must be located in the `~cbsd/etc` directory (for example, `/usr/jails/etc`), while the original CBSD profiles are in directory `~cbsd/etc/defaults` (for example, `/usr/jails/etc/defaults`)

If you edit files in the `~cbsd/etc/defaults` directory, all your changes will be deleted each time you update **CBSD**

If you want to overwrite the original profile, just copy it to the `~cbsd/etc` directory and edit it. In this case, with the same profile names, the system will always prefer the profile from the `~cbsd/etc` directory, despite its presence in the `~cbsd/etc/defaults` directory.
When creating a new profile, please observe the following rules:

* the file name must begin with vm-"os-type"-XXX.conf, where os-type - type of OS, e.g: freebsd, openbsd, linux, windows, other
* Inside the profile this arguments are mandatory: **long_description, vm_profile и vm_os_type**

Where:

* **long_description** contains an arbitrary description, for example: long_description="Linux Debian 9.2.1"
* **vm_os_type** - contains the OS type and must also be in the file name. So, if the OS type is linux, write: vm_os_type="linux", and the profile file will begin with vm-linux-
* **vm_profile** - the name of the profile, which also forms part of the profile file name. For example, if you created a profile for Debian 9.2.1, you can write vm_profile="Debian-9.2.1", and the full name of the profile file will be: vm-linux-**Debian-9.2.1.**conf

The remaining parameters are optional (as the number of cores, RAM, the default virtual machine name, various bhyve settings), and if they are not in the profile, common values will be used from `etc/defaults/bhyve-default-default.conf`, which you can also copy it to `etc/bhyve-default-default.conf` if the global parameters do not suit you and you want to edit them

 The remaining parameters are optional (as the number of cores, RAM, the default virtual machine name, various bhyve settings), and if they are not in the profile, common values will be used from `etc/defaults/bhyve-default-default.conf`, which you can also copy it to `etc/bhyve-default-default.conf` if the global parameters do not suit you and you want to edit them

Also, look at the **fetch, iso_img, register_iso_name**, and **register_iso_as** options.

If you create a virtual machine profile that you can retrieve over the network, you will most likely need them.

fetch says **CBSD** whether an ISO image is available for download (0-no, 1-yes)

iso_img points to the name of the ISO image, as it is called from the source where to download it (for example, ubuntu-17.04-server-amd64.iso)

The parameters register_iso_name and register_iso_as control how to save the image to be downloaded and under what name to register in CBSD media, for example:

```
register_iso_name="cbsd-iso-ubuntu-17.04-server-amd64.iso"
register_iso_as="iso-Ubuntu-Server-17.04"
```

If an ISO image is downloaded from the site, but an archive with an ISO image, for example **.tgz or .gz or .xz** etc. (for example, the **vm-dflybsd** - profile), you can specify the command to unzip, using the **iso_extract** parameter, for example:

```
iso_extract="bzip2 -d "
```
And of course, it's always useful to see how original images are written, the profile of which can be taken as a basis.

```
*** If you created a working OS profile, you can send it to the repository https://github.com/cbsd/cbsd-vmprofiles having an account on GitHub, thereby making other users CBSD happy. Also, this profile will be included in the next release of CBSD and you will become participant of the project!
```
Options and their brief description, which appear in the dialogue form. Depending on the type and profile of the OS, some of them may not be available:

* vm_os_type - type of OS. Depending on the type of the guest OS will be offered a particular profile set distributions
* vm_os_profile - select the profile distribution. A profile can contain as proposed default parameters described below, as well as specific distro settings (URL for the image, kernel boot options, etc.)
*imgsize - Size for the first virtual image. If the guest OS - FreeBSD profile and FreeBSD-from-jail (image generation through jail2iso), this parameter indicates the amount of free space after copying distribution
* jname - the name of the virtual machine, in a one word.
* host_hostname - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: set the hostname in /etc/rc.conf guest OS to the appropriate value
* vm_ram - allocated RAM
* vm_cpus - the number of virtual cores
* vm_hostbridge - guest OS host bridge. Maybe hostbridge or amd_hostbridge (affects the PCI vendor ID)
* astart - sign automatically start the virtual machine with the boot node
* interface - uplink interface for tap-interface, the first network card of the virtual machine
* pkglist - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: select the appropriate pekedzhi to be pre-installed in the created VM
* ip4_addr - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: set the ifconfig_NIC /etc/rc.conf in the guest OS to the appropriate value - can be an IP address or a 'DHCP'
* gw4 - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: install defaultrouter parameter /etc/rc.conf guest OS to the appropriate value
* ver - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: use the base and kernel of the specified version (for example 10.1, 11.0, 12)
* applytpl - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: whether to apply additional settings (/etc/hosts, /etc/make.conf)
* floatresolv - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: set /etc/resolv.conf servers listed in the parameter jnameserver
* arch - relevant only to the guest OS FreeBSD and Profile FreeBSD-from-jail: use the base and kernel of this architecture (eg i386, amd64)

**Example:**

```
% cbsd bconstruct-tui
```
![](img/bcreate7.png)

Guest OS type:

![](img/bcreate8.png)

Choosing profile for Linux type guest:

![](img/bcreate9.png)

Choosing VM name:

![](img/bcreate10.png)

Choosing bhyve UEFI boot method:

![](img/bcreate11.png)

Choosing bhyve VNC params:


![](img/bcreate12.png)

Choosing bhyve params:

![](img/bcreate13.png)

