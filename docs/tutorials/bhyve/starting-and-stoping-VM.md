# Starting and stoping VM

**commands: bstart, bstop**

```
% cbsd bstart jname=vm1
% cbsd bstart vm1 vm2 ... vmX

% cbsd bstop jname=vm1
% cbsd bstop vm1 vm2 ... vmX
```

** Description:**

**bstop** command send SIGTERM signal to virtual domain for soft shutdown. In the event that the virtual machine does not stop during **hard_timeout** (by default: **30**) seconds, CBSD will terminate the process forcibly. Use **noacpi=1** args for instant/hard poweroff (without sending SIGTERM) virtual environment or **hard_timeout=X** to change the interval wait for soft off

Running virtual machines happens when you start cbsd/server automatically if parameter **astart** (auto-start) corresponding VM is set to 1 This setting can be through **cbsd bconfig** or **cbsd bset**. When you stop the server or service **cbsdd**, automatically stops all running virtual machines. Running VM manually by the command:

```
% cbsd bstart jname=vm1
```

or

```
% cbsd bstart vm1
```
or

```
% cbsd bstart vm1 vm2 vm3 ..
```

(to run multiple virtual machines as a command)

If the start/bstop command run with no arguments, this will list all inactive/active VM for interactive selection

If you have the appropriate build of FreeBSD and **CBSD** not less **11.2.0**, you can take advantage of instant start of the virtual machine from [checpoint](Checkpoints-hibernation-and-pauses.md), bypassing the boot phase. To do this, use the argument **checkpoint=** with name of checkpoint
