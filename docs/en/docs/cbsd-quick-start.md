# CBSD Quick Start Guide

## Initialization

Install CBSD from ports or pkg:

```
make -C /usr/ports/sysutils/cbsd install
pkg install -y cbsd
```

Configure the working directory in /usr/jails and initialize:

```
env workdir=/usr/jails /usr/local/cbsd/sudoexec/initenv
```
In most cases, the default parameters are acceptable, just press Enter if you agree with them

If you have any questions about customization, please see the page Initial setup


## Create and run jail

Run the container creation configurator

```
cbsd jconstruct-tui
```

run jail

```
cbsd jstart
```


## Create and run bhyve

Run the VM creation configurator

```
cbsd bconstruct-tui
```

run bhyve

```
cbsd bstart
```
