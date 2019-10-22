# CBSD with DFS (Distributed File System)

## General information

One of the distinguishing features of **CBSD** from other modern wrappers for managing jail and bhyve on the FreeBSD platform is the lack of a rigid binding to the ZFS file system, which leads to a certain overhead in terms of code when you use only ZFS, but makes **CBSD** a more versatile tool that you can use in more general situations.

One such situation is the use of various embedded platforms with very few resources where the ZFS file system is redundant and voracious, which makes it ineffective on various Raspberry PI and similar solutions. On the opposite side of the minimalism are large and large-scale hyperconvergent installations using NAS/SAN and distributed storage systems, using external storage that is connected as a shared storage via NFS or distributed storage systems like ClusterFS and Ceph.

This will highlight the use of **CBSD** in these installations and describe the How-to-style application notes.

The general requirement for using **CBSD** on DFS, which is typical for any implementations, is turning off the *zfsfeat* option and *hammerfeat* option in 'cbsd initenv-tui' and the need to bring the following directories to the shared store:

* ~cbsd/jails-data: directory with container or virtual machine data
* ~cbsd/jails-system: system directory with additional system information related to the container or virtual machine
* ~cbsd/jails-rcconf: the directory is used when the environment switches to unregister mode

If the working directory (**workdir**) is initialized in /usr/jails this is, respectively, the directories:

```
/usr/jails/jails-data
/usr/jails/jails-system
/usr/jails/jails-rcconf
```

That's all. Other directories, such as bases, you can also put on a shared volume to save space. However, it is much more efficient to store the base container files locally, which with the **baserw=0** parameter guarantees the operation of the basic utilities and libraries with the speed of the local disk and the absence of possible network problems.

Shared storage provides an easy way to migrate a zero-copy environment. So, you can move the container to the **unregister** state on one node:

**node1**:
```
% cbsd junregister jname='*'
```

and having registered, without any copying, start using it on another:

**node2**:

```
% cbsd jregister jname='*'
```
Known issues.

Some DFS, such as NFS and GlusterFS, require additional configuration in pkg.conf for correct locking:

```
% echo "NFS_WITH_PROPER_LOCKING = true;" >> /usr/local/etc/pkg.conf
```
## CBSD with NFS

Using **CBSD** with NFS (option when NFS is not a dedicated NAS, but one of three **CBSD** nodes)

Through various failover mechanisms, such as carp(4),**pacemaker/corosync, keepalive, sentinel/consul,** you can create a fully automatic faylover when, when you exit the NFS server, any other node is selected as the repository, and the rest are reconfigured to it. However, these settings are beyond the scope of this article, designed to give surface data about DFS.

So, on the first of the three servers we selected as an NFS server, configure the /etc/exports file by listing the IP or subnets of the NFS-merge. We assume that the servers are completely under our control and are completely trusted, since we will be able to export all the directories.

For example, our three CBSD nodes have the following addresses: **192.168.10.201 192.168.10.202 192.168.10.203** and the **workdir** working directory is everywhere initialized to */usr/jails*.

Add the corresponding NFSv4 line to */etc/exports*:

```
V4: / 192.168.10.201 192.168.10.202 192.168.10.203
```
If your servers are installed on the ZFS file system, do not forget to include the sharenfs option on the required or on the root dataset on the NFS server. For example, if the ZFS root system is zroot/ROOT/default, then NFS export is enabled through the following command:

```
% zfs set sharenfs=on zroot/ROOT/default
```
In */etc/rc.conf*, add the necessary services to start the NFS server by running:

```
sysrc -q nfs_client_enable="YES"
sysrc -q nfs_server_enable="YES"
sysrc -q nfsv4_server_enable="YES"
sysrc -q nfscbd_enable="YES"
sysrc -q nfsuserd_enable="YES"
sysrc -q rpcbind_enable="YES"
sysrc -q mountd_enable="YES"
sysrc -q nfsuserd_enable="YES"
sysrc -q rpc_lockd_enable="YES"

```
If you plan to do a failover and thus, any cluster element can become an NFS server, so we will duplicate these parameters on all other **CBSD** nodes, especially since some of them are necessary for the NFS client. After rebooting servers or services, NFS is ready to work.

Configuring clients. In our case, the NFS server has an IP address of 192.168.10.201, resp. replace this address with one that matches your server. You can mount the directories in manual mode using the following commands:

```
% mount_nfs -o vers=4 192.168.10.201:/usr/jails/jails-data /usr/jails/jails-data
% mount_nfs -o vers=4 192.168.10.201:/usr/jails/jails-system /usr/jails/jails-system
% mount_nfs -o vers=4 192.168.10.201:/usr/jails/jails-rcconf /usr/jails/jails-rcconf

```
You can use the /etc/fstab file with the 'late' option to mount directories when the node starts, or use automount ( autofs(5) )
Now you can create your container on any of the nodes and through a migration or a sequence of commands:

```
node1 % cbsd junregister jname='jail*'     // on the source node where the jail is registered
node2 % cbsd jregister jname='jail*'       // on another/destrination node
```
And migrate your environments by distributing and scaling the load on your cluster more smoothly.

## CBSD and GlusterFS

WIP. Short howto available here: CBSD with GlusterFS

## CBSD and CEPH

comming soon
