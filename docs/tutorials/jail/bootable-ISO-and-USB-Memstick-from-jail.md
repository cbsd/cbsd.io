# Generation of bootable ISO and USB Memstick from jail

## jail2iso command

```
% cbsd jail2iso
```
**Description:**

The **jail2iso** script allows tirmomg a specified jail into bootable images for CD/DVD/Memstick media or the **bhyve** hypervisor. Despite **jail2iso** not being used by **CBSD** itself for its operation or jails, the script can be very useful for easy and comfortable creation of customized LiveCDs, and testing their configuration in a jail environment. This functionality can be useful when:

*  Creating rescue-system with desired tools
*  Building your own FreeBSD distribution
*  Creating images for diskless servers/stations (eg booted from PXE, MicroSD, Flash, CD/DVD, etc.) and have mounted home directories or jails/data files from NFS/FibreChannel/iSCSI/InfiniBand.
*  Transfering environment from jail to a bhyve image to make use of **bhyve** features

## Script job for iso/memstick

*  Creation of file hierarchy of next image consisting of mounted base and data of a jail
*  Creation of MFS/UZIP of an image which will remain in memory. It is used generally for work acceleration in the LiveCD mode, allowing for "cache" often caused utilities and libraries, for example from / to /usr.
*  Mount over MFS of hierarchy of data from file system of the media through nullfs/RO
*  Mount through tmpfs over RO file system for modification in LiveCD mode.

If you need a number of directories reload when loading image in RW via tmpfs, before executing **jail2iso** you needs to be written to a file ``$systemdir/jail/tmpfsdir`` all the path. For example **rescuebsd** jail is a file: `/usr/jails/jails-system/rescuebsd/tmpfsdir` with content:

```
/root
/var/run
/var/cache
/var/db
/var/spool
/var/log
/usr/home
/usr/local/etc
```
These entries are processed `/etc/rc.d/tmpfsdir`, which will save to the image by **jail2iso**. All contents of these files, which is on the jail, will be moved to tmpfs filesystem. As RW areas are mounted through TMPFS, the quantity of memory available to record will depend on quantity of RAM of servers on which LiveCD is started.

You may prefer to write your own `/boot/loader.conf` to created image. To do this, save the file loader.conf in the directory `$systemdir/$jname/`. Everything you write in this file will be added to loader.conf, generated **jail2iso**, which has the following mandatory entries:

```
kern.ipc.shmmni=4096
kern.ipc.shmseg=4096
radeonkms_load="YES"
i915kms_load="YES"
linux_load="YES"
```
You can specify what type of image **jail2iso** is to create, ISO image with cd9960 for CD/DVD/VMs or Memstick, an image that you can burn to a USB Flash drive.

## Script job for bhyve image

Since the image will be initially bhyve mode RW, it does not require the creation of RO image with UZIP and support tmpfsdir, so at this stage there is no formation of an image. The script will automatically create a fstab-entry to mount an appropriate device in bhyve machine and updates /etc/ttys as required [instructions](http://people.freebsd.org/~neel/bhyve/bhyve_instructions.txt). When creating an image bhyve, use the parameter:

```
% cbsd jail2iso ... freesize=
```
Because without this option, create disk volume equal to the volume of evidence, without reserve. This will make the system broken, so through **freesize=** further specify the amount of free space in the image there after copying master data.

For more information

**cbsd jail2iso** is not controlled and does not limit the volume of the final result — they are limited only by your destination media:

For create ISO image use:

```
%  cbsd jail2iso media=iso ..
```
For create memstick image use:

```
% cbsd jail2iso media=memstick ..
```
For create bhyve image use:

```
% cbsd jail2iso media=bhyve freesize=XXg ..
```
Directory where to save the image specified as an argument **dstdir**.

By default, the image will be have GENERIC kernel from `$workdir/basejail/` directory. You can get this kernel via

```
% cbsd repo action=get sources=kernel
```
for your version of FreeBSD, or build it yourself through **cbsd buildkernel**. If the GENERIC kernel is not suitable as an argument **name** for **jail2iso** you can specify a different kernel if you have it.

In addition, to reduce the size of the final image, jail2iso a series of actions:

*  removal .a-archive files in lib directories
*  removing unnecessary data by file list

By default, this list is located in the `$workdir/share/jail2iso-prunelist`. You can correct them if you needed, or create your own, specifying the path to it as an argument **prunelist**

Example of creating memstick from jail1:

```
% cbsd jail2iso media=memstic jname=jail dstdir=/tmp
```
If the file /tmp/jail1.img created, it can be writte to a USB device via the command:

```
dd if=/tmp/mc.img of=/dev/da0 bs="10240" conv="sync"
```
 where /dev/da0 — is USB Flash storage.

Example of creating and launching bhyve image from jail1 with networks via interface **em0**:

```
% cbsd jail2iso media=bhyve jname=jail1 dstdir=/tmp freesize=1g
% kldload vmm
% kldload if_tap
% sysctl -w net.link.tap.up_on_open=1
% ifconfig tap0 create
% ifconfig bridge0 create
% ifconfig bridge0 addm em0 addm tap0
% ifconfig bridge0 up
% sh /usr/share/examples/bhyve/vmrun.sh -d /tmp/jail1-10.0_amd64.img vm1
```
where `/tmp/jail1-10.0_amd64.img` — result from jail2iso.
