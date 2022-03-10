#Working with packages and pkg(7) in jail via CBSD

**Command: pkg**

```
% cbsd pkg
```
**Description:**

**cbsd pkg** - is wrapper around standard FreeBSD [pkg(7)](http://man.freebsd.org/pkg/7) tools to use **jname** argument for more comfort work with the jail from the master host

Via **mode=** argument indicating a needed action. Values can be:

*  **add, install** - to install packages
*  **remove** - to remove packages
*  **bootstrap** - init pkg (normally done in the jail one times on creating)
*  **info, query** - execute queries info or query with the same syntax pkg
*  **update** - execute pkg update
*  **upgrade** - execute upgrade
*  **clean** - execute clean to purge pkg cache

For some commands (clean, update, upgrade) it is permissible jname= to specify as mask for performing the operation simultaneously in several jails

Keep in mind that must first be specified parameters **mode** and **jname**. All that comes after - not analyzed and treated [pkg(7)](http://man.freebsd.org/pkg/7) as is.

In addition, please note that all operations are performed with the set environment variables `ASSUME_ALWAYS_YES=yes` and `IGNORE_OSVERSION=yes` to suppress the interactivity that basically, you need to work in automated scripts. If for some reason this does not work for you, use cbsd rexe to work with pkg directly.


**Example1:** Update pkg index files inside ALL containers:

```
% cbsd pkg mode=update jname='*'
```
**Example2:** Update ALL packages inside containers, whose name starts with redis*:

```
% cbsd pkg mode=upgrade jname='redis*'
```

**Example3:** Clear pkg cache in ALL containers:

```
% cbsd pkg mode=clean jname='*'
```
**Example4:** Get installed packages for box1 and for all jails with jname mask 'jail*' (in **CBSD 11.2.1+**):

```
% cbsd pkg mode=query jname=box1 %o
% cbsd pkg mode=query jname='jail*' %o
```
or that much better (in order to avoid the same name in different categories) indicate origin package, not the name:

```
% cbsd pkg mode=install jname=mytest1 shells/bash ftp/wget misc/mc
```

**Example6:** Upgrade mc package in jail1:

```
% cbsd pkg mode=upgrade jname=jail1 mc
```

**Example7:** Remove wget and lsof packages in box1 and mc from all jails with jname mask 'jail*' (in CBSD 11.2.1+):

```
% cbsd pkg mode=remove jname=box1 wget lsof
% cbsd pkg jname='jail*' mode=remove mc
```

