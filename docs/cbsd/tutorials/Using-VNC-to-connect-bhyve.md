# Using VNC to connect to the bhyve virtual machine

**Commands bconfig, bconstruct-tui**

```
% cbsd bconfig
% cbsd bconstruct-tui
```

Description:

Currently, VNC is possible only when the virtual machine startup through UEFI mode

To do this, when you create a new virtual machine (or editing through bconfig), make sure that:

value of **vm_efi** set to **uefi**:

![](img/bcreate11.png)


f you want to fixate the VNC port, use the menu item **vm_vnc_port**

If **vm_vnc_port** set to **0** - CBSD automatically find the first available port for the VNC connection

If **vm_vnc_port** set to **1** - CBSD it will not open a port for VNC

If **vm_vnc_port** any other numerical value, for example **5905** - CBSD will always use current VNC port for a virtual machine

Beginning with CBSD version 11.1.0, a VNC connection requires a password that is specified in the vnc.conf configuration file (`~cbsd/etc/defaults/vnc.conf`):

In order to change (or remove) the password, duplicate your own value of **default_vnc_password** via `~cbsd/etc/vnc.conf` file:

```
% echo default_vnc_password='test' > ~cbsd/etc/vnc.conf
```
If default_vnc_password takes an empty value, the password for the VNC was not set.

Note that by default, the VNC port opens on loopback address: 127.0.0.1

This is done for security reasons, or any user can connect to the VNC conclusion of your virtual machine

To connect to the VNC on a remote server, please use SSH tunnels, or any proxies that are protected by a password or a certificate

If you want to work with VNC directly, just change the parameter **bhyve_vnc_tcp_bind** from 127.0.0.1 to 0.0.0.0 via **vnc_options** menu. In this case, to connect the port to be opened all

![](img/bcreate12.png)


