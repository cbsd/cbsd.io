# Removal Virtual Machine

**command: bremove**

```
% cbsd bremove jail1 jail2 ..
```
**Description:**

Removing a virtual machine affects all files in one way or another connected with the VM:

    a) directory or ZFS fileset with images of virtual machine
    b) statistics and the description of the virtual machine
    c) snapshots, if it was

In case when bremove runs on a running virtual machine, the work of the guest OS is automatically interrupted.

**Example:**

```
% cbsd bremove redhat1
```
