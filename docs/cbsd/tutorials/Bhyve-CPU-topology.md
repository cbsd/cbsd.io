# Bhyve CPU topology

**Commands: cpu-topology vm-cpu-topology vm-cpu-topology-tui**

```
% cbsd cpu-topology
% cbsd vm-cpu-topology vm-cpu-topology-tui
% cbsd vm-cpu-topology-tui
```
**Description:**

Configuring and viewing the CPU topology of the bhyve virtual machine.

Adjustment of the CPU topology of virtual machines can be performed to improve the performance and optimization of computational operations, and in various tasks related to testing.

When virtual machines executing, it is important to understand that from the point of view of the hoster: the virtual processors of the virtual machine are the usual processes (in the case of bhyve, a separate vcpu is a thread in the hoster system).

It is assumed that the user has a minimal understanding of the work of CPU, memory and NUMA-domains. In addition, for effective configuration it is important to understand the type of activity and services of the OS of a particular guest. The most important is understanding the work of L1, L2 and L3 caches and the work of the processor with certain memory blocks.

Recall that L1, L2 cache is a cache for one core, whereas L3 and higher is a cache for the entire processor (socket).

By changing the topology of the guest operating system, you can define the various virtual processor configurations as the number of sockets, the number of cores per socket and their location, and the presence of hyper-threading.

For example, having 8 cores, you can configure them as:

* 1 socket (virtual process) with 8 core, without hyper-threading ( FreeBSD/SMP: 1 package(s) x 8 core(s) )
* 1 socket with 4 core, with HT ( FreeBSD/SMP: 1 package(s) x 4 core(s) x 2 hardware threads)
* 2 sockets with 2 core and HT ( FreeBSD/SMP: 2 package(s) x 2 core(s) x 2 hardware threads)
* 4 sockets with 2 core each ( FreeBSD/SMP: 4 package(s) x 2 core(s) )
* etc..

As such, the configuration of the virtual machine topology does not affect the speed of the virtual machine itself:

![](img/cpu_topology_intro.png)

The configuration data becomes important, in conjunction with the settings for binding the virtual machine cores to a particular group of physical server cores (set_affinity, cpu-pinning), as will be discussed separately. The aim of this article is to consider bhyve possibilities and work with its configuration through **CBSD**.

To view the current topology on the host side, use the command cbsd **cpu-topology**. In addition to information about the current system, you can see a schematic representation of the sockets and cores that serve virtual environments

If the virtual machine is bound to a particular core of the physical machine, you will see its name opposite the given kernel of a specific socket. If there are no bindings/pinning, all virtual environments will be opposite each core - since they do not have restrictions on the use of certain kernels and they can migrate than are required by the OS OS master:

![](img/cbsd_cpu_topology1.png)

A socket is directly a physical processor (package) on your motherboard. If the processor supports hyper-threading (and it is enabled), the virtual cores will be marked as THR

You can create any number of profiles for the topology. You can view their list using vm-cpu-topology:

![](img/cbsd_cpu_topology3.png)

You can delete or add new ones through the TUI command interface vm-cpu-topology-tui

![](img/cbsd_cpu_topology2.png)

Profile names must be unique and the application of this or that topology is performed through the command bset, bconfig. And also, the choice of topologies will be available when creating a virtual machine in bconstruct-tui:

![](img/cbsd_cpu_topology4.png)
