# Checkpoints, hibernation and pauses of the bhyve virtual machine

**Commands bcheckpoint, bsuspend, bpause**

The implementation of this feature in **bhyve** is grateful to the Politehnica University of Bucharest and in particular: Elena Mihailescu and Mihai Carabaș

At the time this page was published, this functionality was not available in the FreeBSD codebase and was obtained from the project page on [GitHub (FreeBSD-UPB)](https://github.com/FreeBSD-UPB)

The functionality of checkpoints and suspend of a virtual machine is the freezing of the virtual environment, saving the entire state to disk, from which you can return the system to its previous state without having to reboot the environment

Checkpoints

In **CBSD** to work with checkpoints use the **bcheckpoint** command, which has the following syntax:

```
cbsd bcheckpoint [jname=] [mode=] [name=] [poweroff=]
```
where:

* **jname**: (required) the name of the environment, for example: freebsd1
* **mode**: (required) action relative to the environment: create (create checkpoint), list (list of checkpoints created), destroyall (destroy all checkpoints)
* **name**: (optional) specify an alternate checkpoint name, by default: checkpoint
* **poweroff**: (optional). When poweroff=1, CBSD will automatically shut down the virtual machine instantly (via bstop noacpi=1) on the fact of checkpoint creation.

```
  % cbsd bls
  JNAME     JID    VM_RAM  VM_CURMEM  VM_CPUS  PCPU  VM_OS_TYPE  IP4_ADDR  STATUS  VNC_PORT
  freebsd1  21923  1024    24         1        0     freebsd     DHCP      On      127.0.0.1:5900

  % cbsd bcheckpoint mode=create jname=freebsd1
  Waiting and sure that the info is written on the disk: 1/5
  Waiting and sure that the info is written on the disk: 2/5
  Waiting and sure that the info is written on the disk: 3/5
  Waiting and sure that the info is written on the disk: 4/5
  Waiting and sure that the info is written on the disk: 5/5
  Checkpoint was created!: /usr/jails/jails-system/freebsd1/checkpoints/checkpoint.ckp

  % cbsd bcheckpoint mode=create jname=freebsd1 name=after_update
  Waiting and sure that the info is written on the disk: 1/5
  Waiting and sure that the info is written on the disk: 2/5
  Waiting and sure that the info is written on the disk: 3/5
  Waiting and sure that the info is written on the disk: 4/5
  Waiting and sure that the info is written on the disk: 5/5
  Checkpoint was created!: /usr/jails/jails-system/freebsd1/checkpoints/after_update.ckp

  % cbsd bcheckpoint mode=list jname=freebsd1
  Created checkpoint for freebsd1:
  after_update
  checkpoint
```
Having created checkpoints, you can return to the desired state via the command **bstart** with **checkpoint** args

A short demo at an early stage of development on this video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/cyFDnmTKY_c" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Suspend mode

WIP
VM Pauses

WIP
