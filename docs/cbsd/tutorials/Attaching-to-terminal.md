# Attaching to terminal

**command: bloginA**

```
% cbsd blogin
```

**Description:**

Execute **tmux** session, connecting to the console output of the virtual machine

To disconnect from the terminal (and off tmux session), press the key combination: **Ctrl+b, d** (Hold Ctrl press b, release both key and hit d)

**Example:**

```
% cbsd blogin debian1
```

Starting with the version of CBSD 11.1.2, you can customize the command, redefining the action on you more suitable

This is achieved through the configuration file blogin.conf and the parameter **login_cmd**.

The file can be placed for the individual environment in the directory `$workdir/jails-system/$jname/etc`, and globally, overwriting the value from `$workdir/etc/defaults/blogin.conf`. To do this, create a file with your configuration in the directory `$workdir/etc/`

With a custom call, you can use [CBSD variables](../docs/cbsd-variables.md) - for this or that environment

For example, if you want instead of the standard behavior, when the blogin launched the VNC client, the file `$workdir/etc/blogin.conf` can look like this:

```
login_cmd="su -m user -c \"vncviewer ${bhyve_vnc_tcp_ipconnect}:${vm_vnc_port}\""
```

If you want the ssh connection to occur, this file might look like this:

```
login_cmd="/usr/bin/ssh your_user@${ipv4_first}"
```

![](img/blogin1.png)


![](img/blogin2.png)
