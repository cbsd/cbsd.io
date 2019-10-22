# Custom behavior settings by exit codes

**Commands: bconfig, bset, bconstruct-tui**

```
% cbsd bconfig
% cbsd bset
% cbsd bconstruct-tui
```

**Description:**

Configuring the behavior of the virtual machine at exit codes

Beginning with version 12.0.4 of CBSD, a behavior regulator has been added, depending on the virtual machine hypervisor exit code

You can reassign this behavior as a global profile (`bhyve-default-default.conf`), and/or individually for each virtual machine

To edit, you can use bset or the corresponding menu item in the bconstruct-tui or bconfig

Possible exit codes you can use:

* **on_poweroff**: the content of this element specifies the action to take when the guest requests a poweroff
* **on_reboot**: the content of this element specifies the action to take when the guest requests a reboot
* **on_crash**: the content of this element specifies the action to take when the guest crashes

Possible behaviors that you can remap for each code:

* **destroy**: the domain will be terminated completely and all resources released
* **restart**: the domain will be terminated and then restarted with the same configuration
* **preserve**: the domain will be terminated and its resource preserved to allow analysis (WIP, at the moment: XEN only)
* **rename-restart**: the domain will be terminated and then restarted with a new name (WIP, at the moment: XEN only)

![](img/bhyve_exit_behavior1.png)

![](img/bhyve_exit_behavior2.png)

![](img/bhyve_exit_behavior3.png)
