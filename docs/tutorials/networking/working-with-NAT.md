# Working with NAT

**natcfg, naton, natoff commands**

```
% cbsd natcfg
% cbsd naton
% cbsd natoff
```

**Description:**

Jails do not always require external IP, or, for security reasons, a number of services need to deploy on private IPs, so they were not available from the Internet. Thus, the jails may be needed for Internet access.

In this case the NAT translating the private IP address of the jails to external IP of the server. **CBSD** functional has a configuration template NAT rules for translating of private networks [RFC1918](http://tools.ietf.org/html/rfc1918). To do this, this command as the first step is required:

```
% cbsd natcfg
```
for selecting the appropriate framework for which the configuration will be loaded NAT: pf, ipfw and ipfilter. The names of the relevant frameworks

!!! attention

    When you configure this, system file /boot/loader.conf nodes will be modified to load the appropriate modules.

Selection framework and IP for NAT alias executed when you first start **cbsd initenv**, can later be reconfigured through **cbsd initenv-tui** To natip changed in force, you must run **cbsd natcfg** and **cbsd naton** again. Currently, the cbsd configuration NAT limited to the creation of rules for translating private networks. If you need to get something more from simple NAT rule, you can edit the rules file created manually in the directory `$workdir/etc/` in files:

*  **pfnat.conf**, when PF is used
*  **ipfw.conf**, when IPFW is used, or
*  **ipfilter.conf**, wnen using IPNAT from IPFilter

Note:

If nodeip (IP of nodes), he is within RFC1918 networks for the subnet broadcast NAT rule will not be created. To disable nat control by **CBSD**, use the follow command:

```
% cbsd natoff
```

!!! attention

    Be careful, if you activate NAT through ipfw. This rule loads the module ipfw.ko, the settings of which are prohibited by default all packets. If you spend this operation remotely, you can through /boot/loader.conf enable ipfw rule, by default allowing all packets:

```
ipfw_load="YES"
net.inet.ip.fw.default_to_accept=1
```

Example. Start the configurator and activate the NAT through pf, with aliasing-IP as 192.168.1.2, previously initialized in `/etc/rc.conf`:

```
% cbsd natcfg
Configure NAT for RFC1918 Network?
[yes(1) or no(0)]
yes
Set IP address as the aliasing NAT address, e.g: 192.168.1.2

Which NAT framework do you want to use: [pf]
(type FW name, eg pf,ipfw,ipfilter or "exit" for break)

% cbsd naton
No ALTQ support in kernel
ALTQ related functions disabled
No ALTQ support in kernel
ALTQ related functions disabled
pfctl: pf already enabled
```
