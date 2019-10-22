# Bhyve and cloud-init with CBSD

## Commands: bconfig, bconstruct-tui, cloudinit

```
% cbsd bconstruct-tui
% cbsd cloudinit
```
**Description**:

FYI: Cloud-init demo was demonstrated in Bhyve unattended installation with CBSD: PXE and cloud-init

<iframe width="560" height="315" src="https://www.youtube.com/embed/QK9eSxrs3eg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Currently, the use of [cloud-init](https://cloud-init.io/) is a the factor method for rapidly deploying virtual instances in various cloud environments (OpenNebula, OpenStack, Amazon AWS, Microsoft Azure, Digital Ocean ..)

Starting from version 12.0.6 **CBSD** supports the configuration of cloud images using the cloud-init function.

How it works:

Currently, **CBSD** is able to configure the instans of cloud-init using the **NoCloud data source method**. This means that the virtual machine receives all the settings through the file system *fat32/msdos_fs or cd9660* of the connected local media. The task of **CBSD** is to generate and connect the image to the virtual machine at the time of its launch.

As a sign that **CBSD** should activate cloud-init functions, is the fact that there is a cloud-init directory in the system directory of a individual virtual machine: `${jailsysdir}/${jname}/cloud-init/`. In addition to the sign of activation of cloud-init, this directory acts as a repository of configuration in the format and hierarchy of cloud-init, which will be provided to the virtual machine. That is, if the **CBSD** working directory (`cbsd_workdir`) is initialized in the `/usr/jails` directory, for the virtual machine named vm1 the enable flag and parameters for configuring cloud-init should be in `/usr/jails/jails-system/vm1/cloud-init` directory.

For configuration format and configuration options for cloud-init, refer to the relevant official project information.

In addition, the **CBSD** distribution includes an example of a simple configuration that you can view in the `/usr/local/cbsd/share/examples/cloud-init` directory and use as a starting point for creating your own cloud installations.

```
*** Attention! Despite the lack of binding to ZFS, installation using ZFS is recommended for use with cloud-init. In this case, CBSD uses COW technology in the form of a zfs clone to create a virtual machine based on the cloud image. Otherwise, CBSD each time will be forced to perform a lengthy operation with a standard copy of the cloud image on the virtual machine disk. However, it is still much more efficient than installing via ISO using the installer every time.

```

```
*** Attention! In some cases, you may need a runtime configuration, for example, when using network-config version 1. Unlike version 2, where you can use the match parameter with wildcard as the network interface name, the first version requires a strong interface name. Which may vary depending on the numbering of the PCI bus. In this case, you may need the opportunity pre/post start/stop hooks in CBSD, which helps you create dynamic configurations for cloud-init.
```

In addition, an assistant for cloud-init was added to the **CBSD** virtual machines configurator via bconstruct-tui, which implements the minimum required configuration to get a running virtual machine from the cloud image. For this you can use several pre-configured profiles with the **cloud-** prefix.

The number of profiles will increase over time. In addition, you can independently create and send a profile through a public [GitHub repository](https://github.com/cbsd/cbsd-vmprofile). These are the profiles that the **CBSD** uses.

In addition, if you notice that image acquisition speed is low (**CBSD** uses its own mirrors to duplicate images referenced by **CBSD** profiles), and you have a desire to help the project, please read the information on how to raise your own mirror: fetch_iso. You can send us a link to your mirror (or add it yourself via [Github](https://github.com/cbsd/cbsd-vmprofile), and thereby improve the quality for your country/region.

Note: In **CBSD** version 12.0.8, parameter **ci_user_pubkey_user** can accept not only ssh pubkey itself, but also the path to authorized_keys. In addition, if this parameter is set to **.ssh/authorized_keys** (value by default for 12.0.8+), this means that your node's ssh key will be used. ( `~cbsd/.ssh` ). Pay attention to how looks [blogin.conf](https://github.com/cbsd/cbsd/blob/v12.0.8/etc/defaults/blogin.conf#L21) in 12.0.8: if the virtual machine is created using cloud-init, the "cbsd blogin" command will use the custom login command using the node key and the user specified by you as **ci_user_add**.Thus, by running a virtual machine from cloud-init, you can immediately access it via ssh using the command: **cbsd blogin**.

## Usage example

Profiles of cloud images are in the vm_os_profile menu. Select this item in the main menu:

![](img/cloudinit1.png)

At the bottom of the list, you will see an area with Cloud images, if these profiles are created in **CBSD** for the selected OS family:

![](img/cloudinit2.png)

Next, configure the network settings, user and public key of the guest machine:

![](img/cloudinit3.png)

![](img/cloudinit4.png)

Further configuration and launch of a cloud-based virtual machine is no different from the main method. Good luck!
