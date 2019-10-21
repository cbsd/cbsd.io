
# Virtual Machine Configuring
**commands: bconfig, bset**

```
% cbsd bconfig
% cbsd bset
```
**Description:**

Configuring the Virtual Machine Settings

Each virtual machine **CBSD** stores the settings in the SQLite3 database. To change the settings of a VM can serve command **cbsd bconfig**, TUI launches menu for changing the basic settings.

Description of relevant parameters, you can read on the page [VM create](bhyve-virtual-machine.md)

**Custom scripts for starting and stopping action on jail**

You can write your own scripts to be executed within the jail and in the master host on startup and shutdown of the environment. For this, the system directory of jail ( `$workdir/jails-system/$jname/` ) have the following directories:


* **master_poststart.d** - scripts for executing in the master host after jail starts (Be careful, because the scripts are is not jailed)
* **master_poststop.d** - scripts for executiong in the master host after jail stops (Be careful, because the scripts are is not jailed)
* **master_prestart.d** - scripts for executing in master host before jail starts (Be careful, because the scripts are is not jailed)
* **master_prestop.d** - scripts for execution in master host after jail stops (Be careful, because the scripts are is not jailed)
* **start.d** - scripts for execution within jail when jail is starts. Analog of parameter **exec.start** from original jail.conf
* **stop.d** - scripts for execution within jail when jail is starts. Analog of parameter **exec.stop** from original jail.conf
* **remove.d**- (since CBSD 11.0.10) scripts for execution on remove command

Write scripts to the *master_\* * directories can be useful if at the start-stop jail you need to perform some action is not associated with content of environment - for example, create a ZFS snapshot, put rules in IPFW and etc.

In scripts, you can use **CBSD** variables, such as **$jname, $path, $data, $ip4_addr**, for example, by placing a script (with execute permission) in `/usr/jails/jails-system/jail1/master_poststart.d/notify.sh`:

```
#!/bin/sh
echo "Jail $jname started with $ip4_addr IP and placed on $path path" | mail -s "$jname started" root@example.net
```

You will receive notification upon startup cells by email: root@example.net

The functionality of execution custom scripts and the availability of variables in environments can play a big role in the integration of **CBSD** and external applications, such as **Consul**

As an example of use, see the article [Example of using CBSD/bhyve and ISC-DHCPD (Serve IP address in bhyve through pre/post hooks)](jail-config.md)

As an example of use, see the article [Example of using CBSD/jail and Consul (Register/unregister jail's via pre/post hooks, in Consul)](jail-config.md)
