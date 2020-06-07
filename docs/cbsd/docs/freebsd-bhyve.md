# FreeBSD: bhyve

## Intro

[**bhyve**](http://man.freebsd.org/bhyve/8) is a hypervisor, kindly opened by a company [NetApp](http://www.netapp.com/us/) (having its own operating experience on the basis of FreeBSD OS) under the BSD license and currently included in the boxed / basic version of the FreeBSD OS, unlike a number of similar projects that are not part of the OS and their (or their modified kernels), you must first download and install. In other words, all FreeBSD releases starting at 10.0 are able to run \*BSD, Linux and various other OSes right out of the box.

At the moment, there is a fairly large number of wrappers to manage bhyve, along with the base script `/usr/share/examples/bhyve/vmrun.sh` and differing among themselves by set goals.

The main goals set by the **CBSD**:

* Require the user a minimum of actions to fully start using bhyve.
* Require a minimum for memorize tons of instruction and arguments from the user, and constant reading of the documentation: everything should be accessible/transparent for control via WEB or text user-interface.
* Integration of bhyve with other FreeBSD components (NFS, glusterfs, iscsi, HAST, carp) out of the box.
* Integration of bhyve with external services (DHCPD, Consul).
* Orientation to large installations, beyond the localhost-only usage.

For convenience, the bhyve control commands in CBSD are similar to the jail control commands, but start with a **b** letter:

* **jstart** (jail start) -> **bstart** (bhyve start)
* **jstop** (jail stop) -> **bstop** (bhyve stop)
* **jls** (jail list) -> **bls** (bhyve list)
* **jconstruct-tui** (jail constructor) -> **bconstruct-tui** (bhyve constructor)
* and so on.

Using **CBSD**, you can combine in one tool management for both jail containers and virtual machines on the bhyve hypervisor, using this or that approach in different tasks.

Additionally, you can consider [jails vs. bhyve comparison](../tutorials/Virtual-Machine-Configuring.md).

## Getting Started with bhyve

To get started with bhyve via **CBSD**, type in the command line:

```
% cbsd bconstruct-tui
```

If your system lacks any components or settings, you will see the appropriate prompts that need to be performed.
When ready, you will see a dialog-based menu for creating a virtual machine:

![](img/bconstruct-tui1.png)

The options **vm_os_profile**, **jname** and **imgsize** are mandatory for manual input.
Start creating a virtual machine by selecting the OS type and selecting the OS profile.

If you start the virtual machine for the first time, the corresponding image from official sites will automatically be downloaded.

A number of parameters (bhyve arguments) are available in the submenu **bhyve_options**:

![](img/bconstruct-tui2.png)

and **vnc_options**:

![](img/bconstruct-tui3.png)

Please note that when you enter the *imgsize* parameter, you specify the amount of the first (boot) virtual hard disk.

To add additional drives or network cards, use the **cbsd bconfig** command after creating the VM.

By default, virtual machines use the **tap** interface, which **CBSD** automatically switches to the **bridge** on your uplink interface (you can change the interface through the **nic_parent** menu in 'cbsd bconfig' &rarr; bhyvenic &rarr; nic1).

You may prefer two other switching options available in **CBSD**:

* Use virtual switch based on [vale(4)](http://man.freebsd.org/vale/4). To do this, use the dialog to create a switch through: **cbsd valecfg-tui**.
* You can exclude the bridge and use a point-to-point connection. To do this, through 'cbsd bconfig' &rarr; bhyvenic &rarr; nic1, you need to change the **nic_parent** parameter to **disable**. In this mode, you must assign an IP address as the gateway to your virtual machine on the tap interface.

!!! warning
    Note the presence of a menu for selecting the bhyve IP address in the bconstruct-tui menu.

    Keep in mind that without auxiliary scripts inside the distribution or virtual machine, you can not manage the settings in the virtual machine itself from the outside.

    This menu item saves the IP address in the CBSD database so that you can configure third-party methods (for example via DHCP) to automatically configure the OS without having to put your own scripts inside.

    As an example, look at the article: [CBSD/bhyve](https://www.bsdstore.ru/en/articles/cbsd_vm_hook_dhcpd.html) and DHCPD.
