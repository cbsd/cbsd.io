# List of Virtual Machines

**comannd bls**

```
% cbsd bls
```
Description:

Displays the list of virtual machines on the local node or all of the added nodes. through argument display you can specify the fields to fetch the data. If display not specified, the value specified in the file `$workdir/etc/defaults/jls.conf`, which you can change at its discretion through `$workdir/etc/bls.conf`

All possible parameters for samples described in the file `$workdir/share/local-bhyve.schema`

*  **JNAME** — Name of virtual machine
*  **VM_RAM** — memory space, in MB
*  **VM_CPUS** — The number of virtual CPU cores
*  **VM_OS_TYPE** — Guest OS type
*  **PATH** — directory in which there are images of hard disks of the virtual machine
*  **STATUS** — state of virtual machine

If added to the local server RSA/DSA keys remote node, you can display all the virtual machines in the farm through

```
% cbsd bls alljails=1
```
or

```
% cbsd bls alljails=1 shownode=1
```

to display the name of the node that hosts this virtual machine.

**Example:**


```
% cbsd bls
```

![](img/bls1.png)
