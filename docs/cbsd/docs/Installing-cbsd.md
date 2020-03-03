# Installing CBSD


This guide assumes that you are installing CBSD on a freshly installed FreeBSD system as a number of configuration files [can be changed during install](https://www.bsdstore.ru/en/custom_freecbsd.html).


For full functionality it is advisable to have the following:

  +  FreeBSD version greater or equal of 10.0-RELEASE.
  +  amd64 architecture, because the development of CBSD is carried out under this architecture.
  +  ZFS file system, due to the use of several ZFS features.
  +  kernel with RACCT/RCTL and VIMAGE support (CBSD can fetch out a kernel from own repository with your consent)


## CBSD versioning


The first two digits of the **CBSD** version indicate the FreeBSD version for which it was developed and tested. Version 10.1.3 means that scripts were written for FreeBSD 10.1. The third number is the **CBSD** version.

## Preparing the system and installing CBSD


**1a) Installing from ports or packages**

**CBSD** can be installed from FreeBSD ports:

```
% make -C /usr/ports/sysutils/cbsd install
```

or as a package:

```
% pkg install cbsd
```

**1b) Installing experimental (development) version of CBSD from github**

 *( For developers or contributors, or those who want to take advantage of new features at the expense of stability and reliability )*

 a) First install the required dependencies: **libssh2, sudo, rsync, sqlite3**


```
% pkg install sudo libssh2 rsync sqlite3 git
```

or from the ports:

```
% make -C /usr/ports/security/sudo install
% make -C /usr/ports/security/libssh2 install
% make -C /usr/ports/net/rsync install
% make -C /usr/ports/databases/sqlite3 install
% make -C /usr/ports/devel/git install
```

b) get the latest version of **CBSD** from [github](https://github.com/):

```
% git clone https://github.com/cbsd/cbsd.git /usr/local/cbsd
```

c) create a **CBSD** user (when installing from ports or pkg's this is unnecessary):

```
%  pw useradd cbsd -s /bin/sh -d /nonexistent -c "cbsd user"
```

d) create links of the rc.d scripts to start **CBSD** at system startup and create link to bsdconfig module (when installing from ports and pkg's it is unnecessary):

```
% cd /usr/local/etc/rc.d
% ln -s /usr/local/cbsd/rc.d/cbsdd
% ln -s /usr/local/cbsd/rc.d/cbsdrsyncd
% mkdir -p /usr/local/libexec/bsdconfig
% ln -s /usr/local/cbsd/share/bsdconfig/cbsd /usr/local/libexec/bsdconfig/cbsd
```

## initenv

**2) Initial setup**

In the classic install, there are two copies of **CBSD**. One of them (`/usr/local/cbsd`), contains a distribution kit, initial code and configuration files by default. This copy can qlwo be used to manage jails in case the main copy is damaged (for example after an incorrect update). Scripts to work with can be found in the environment variable **workdir**.

To initialize the main working copy of **CBSD** we need to run **initenv**, while setting the environment variable **workdir** to the location of the working directory. We then answer a series of questions to complete the configuration. The file system for **CBSD** (or rather, the directory jails-data in it) needs to be large enough to accommodate the jail's data. After finalizing the location of the working directory, ensure it is set as the home directory for **CBSD** user (in this case the working directory in `/usr/jails`):

Initialization with the working catalogue into `/usr/jails`:

```
% env workdir="/usr/jails" /usr/local/cbsd/sudoexec/initenv
```

The start dialogue will appear with questions on how to configure **CBSD**. Pressing Enter with no entered values will set system defaults. Once done updating **CBSD** it is necessary to run initenv again. After the first run of initenv it can be started through **CBSD** without specifying the **env** variable again and the working dir variable will be stored in `/etc/rc.conf`.

On first initialization the following questions will be asked:


  +  **Please fill nodename** — Node name. If you plan on working with several nodes, this name should be unique. It is recommended to use a name, or full hostname (including domain). This name is used when working with remote hosts. Example: node1.my.domain.
  +  **Please fill nodeip** — Working and static IP address of a node. It shouldn't be an alias and it is desirable to register this IP on a separate interface (free from any other except a management-traffic). For example: 192.168.1.2
  +  **Please fill nodeloc** — Information strings for helpful information in the web interface. Geographic location might be an example of values used here.
  +  **Please fill jnameserver** — List of IP DNS servers to be inserted in the newly created jail's /etc/resolv.conf. If several addresses are added, they must be separated by commas. It is recommended to setup the master-node server for caching DNS queries.
  +  **Please fill nodeippool** — The list of subnets in which jails may be started. If adding more than one network use space as delimer. For example: 10.0.0.0/24 192.168.1.128/29
  +  **Please fill natip** — This specivies the IP address which will represent itself as NAT for private addresses. Usually it is IP of your node. For example: 192.168.1.2
  +  **Please fill fbsdrepo** — Whether or not to use an official FreeBSD repository for base/templates. Expected answers are 1 or 2 . If on official FreeBSD servers base it is not revealed — CBSD repository is used. For example: 1.
  +  **Please fill zfsfeat** — Whether to use features of ZFS (clones, snapshots). The answer 1 or 2 is expected. The question won't be asked, if the host system is started not on ZFS.
  +  **Configure NAT for RFC1918 Network?** — Whether to use network address translation (NAT) for private addresses. When jails are created in RFC1918 networks, it is necessary to enable this for internet access. For example: 1.
  +  **Which one NAT framework should be use: [pf or ipfw]** - What tool for NAT to prefer. Recommended — pf. For example: 1

