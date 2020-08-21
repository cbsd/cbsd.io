# bhyve PCI Passthrough

**Commands bhyve-ppt**

```
% cbsd bhyve-ppt
```
**Description:**

CBSD allows you to configure bhyve arguments to throw devices into the guest, if your hardware supports it

Attention! Read the information on the page [FreeBSD Wiki: bhyve pci_passthru](https://wiki.freebsd.org/bhyve/pci_passthru)

In order to mark the device as passthrough, you must put the parameter in `/boot/loader.conf` as described in the wiki page, for example:

```
pptdevs="2/0/0"
```

If you need to specify more than one device:

```
pptdevs="2/0/0 1/2/6 4/9/0"
```

Please note that when using pptdevs, **vmm** the module must be initialized on `/boot/loader.conf` stage to pick up these records.

If you init/load **vmm** after kernel loading, for example via kldload, then pptdevs will not work.

Next, after booting up the system, make sure that CBSD sees the marked devices. With the command 'cbsd bhyve-ppt mode=list' you should see your devices:

```
% cbsd bhyve-ppt mode=list
5/1/0 :  DGE-528T Gigabit Ethernet Adapter :  D-Link System Inc : -
0/31/3 :  7 Series/C216 Chipset Family SMBus Controller :  Intel Corporation : -
```
Now, by using the ppt device ( **5/1/0** or **0/31/3** in this example) you can attach or detach this device to a specific virtual machine:

```
cbsd bhyve-ppt mode=attach jname=vmname

cbsd bhyve-ppt mode=detach jname=vmname
```

**SR-IOV**

The work bhyve / CBSD was tested including with [SR-IOV](https://en.wikipedia.org/wiki/Single-root_input/output_virtualization) technology

In this case, the ppt devices are no different from those that you configure with pptdevs

```
% cbsd bhyve-ppt mode=list
1/0/131 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/133 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/135 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/137 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/139 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/141 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/143 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/145 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/147 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/149 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/151 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/153 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/155 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/157 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/159 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/161 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/163 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/165 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
1/0/167 : X540 Ethernet Controller Virtual Function : Intel Corporation : -
```
Each VF (Virtual Function) you can connect to any virtual machine through the above: **cbsd bhyve-ppt mode=attach**

