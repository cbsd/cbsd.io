# Jail export

**jail command**

```
% cbsd jexport
```

**Description:**

```
*** Attention: *** command execution allows on jail in status On. However it is necessary to remember (especially for jail with databases) when you import such jails, with a high probability it is possible to got problems with inconsistency filesystem in jails, old .pid files that can break work of the imported jails
```
Export jail into file (*.img). In **jname** arguments you can set jail for export. img-file stored in `$workdir/export` directory. Original jail after exports is not modified

You can control compress level via **compress** arguments

CBSD use [xz(1)](https://man.freebsd.org/xz/1), tools for compress images and you can learn in man page about compress diffrence between compress level.

By default CBSD use **compress=6**. You can disable compression with **compress=0**

**Example** (export mysqljail jail to `$workdir/export/mysqljail.img`):

```
% cbsd jexport jname=mysqljail
```
![](img/jexport1.png)

