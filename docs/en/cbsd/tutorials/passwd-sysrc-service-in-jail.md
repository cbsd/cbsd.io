# Working with passwd(1), sysrc(8), service(8) in jail via CBSD

**Commands: passwd, sysrc, service**

**Description:**

Commands from **bsdconf.d** module - is a wrapper around the standard FreeBSD [sysrc(8)](http://man.freebsd.org/sysrc/8), [service(8)](http://man.freebsd.org/service/8), [passwd(1)](http://man.freebsd.org/passwd/1) for adding jname argument for more convenient work with the services and password in jail from the master host.

Via **jname=** argument specified jail, all that comes after (except passwd, which has yet possible user= ) - not analyzed and treated appropriately utitites as is.

**Example1:** Mark sshd service in jail1 as active:

```
% cbsd sysrc jname=jail1 sshd_enable="YES"
```
**Example2:** Get list of services from jail1:

```
% cbsd sysrc jname=jail1 service -l
```
**Example3:** Enable sshd service in jail1:

```
% cbsd service mode=action jname=jail1 sshd enable
```
**Example4:** Start sshd service in all jails started with jail* jname :

```
% cbsd service mode=action jname='jail*' sshd start
% cbsd service mode=action jname='jail*' sshd onestart
% cbsd service mode=action jname='jail*' sshd status
```
**Example5:** Change password for root user in jail1:

```
% cbsd passwd jname=jail1
```
**Example6:** Change password for web user in jail1:

```
% cbsd passwd jname=jail1 login=web
```
