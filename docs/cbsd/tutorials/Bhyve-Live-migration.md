# Bhyve Live migration

**command: bmigrate**

The implementation of this feature in **bhyve** is grateful to the Politehnica University of Bucharest and in particular: **Elena Mihailescu** and **Mihai Carabaș.**

At the time this page was published, this functionality was not available in the FreeBSD codebase and was obtained from the project page on [GitHub (FreeBSD-UPB)](https://github.com/FreeBSD-UPB)

This functional is a continuation of the [checkpoints](Checkpoints-hibernation-and-pauses.md) functional

Primary requirements:

At the moment, the necessary condition is the presence of DFS, which in the case of **CBSD** should not be a problem ( more: [lack of binding to ZFS](example-cbsd-dfs.md). At the moment, the work tested on **NFSv3,v4** and **GlusterFS** ( **Ceph** in the testing process )

For a successful bhyve live migration procedure, you also need to have servers that are closest to the technical specifications (architecture, CPU). Currently, the bhyve hypervisor does not support alignment of CPU instructions (editing and customization of CPUID) in the presence of different processors (different generation/models)

Besides **CBSD** nodes, which are exchanged virtual machines, must be added to the **CBSD** cluster via the [node](jail-create-via-dialog-menu.md) command.

In the process of live migration, the node-source uses the functionality to create a deferred task on the node-destionation through **cbsd task**, so make sure that you have a running process 'cbsdd' ( is controlled by the **cbsdd_enable=YES** parameter in the `/etc/rc.conf` config file)

To migrate, use the command **bmigrate**, which has two arguments - the name (**jname**) a moving virtual machine and the destination node (**node**)


![](img/bmigration1.png)

During the migration, the script performs a preliminary check for the compatibility of the nodes, including the presence of common/shared directories (this is **jails-data, jails-rcconf, jails-system** directories in the **CBSD** working environment)

![](img/bmigration2.png)

A small demo at an early stage of development:

<iframe width="560" height="315" src="https://www.youtube.com/embed/-IYNSBhtJqw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

A small demo at an early stage of development:

<iframe width="560" height="315" src="https://www.youtube.com/embed/EyEtw8vEcxE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

A small demo at an early stage of development:

<iframe width="560" height="315" src="https://www.youtube.com/embed/q94ZaP2Nqvo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
