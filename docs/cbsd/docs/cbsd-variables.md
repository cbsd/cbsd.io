# CBSD variables

**Description:**

**CBSD** is written taking into account the extensibility and flexibility, giving system engineers the opportunity to increase the functionality of the framework through modules or integration with various other tools through hooks available at various stages of script execution, such as such as [pre/post start/stop](../tutorials/jail-config.md) hooks or customization of blogin/jlogin command.

Here is a list of reserved variables participating in these stages and available for use:

| Option | Description |
|:------| :-----------|
|${jname} | (jail, bhyve, xen) :: the variable contains the name of the environment|
|${allow_devfs} | (jail) :: parameter of jail(8) |
|${allow_dying} | (jail) :: parameter of jail(8) |
|${allow_dying} | (jail) :: parameter of jail(8) |
|${allow_kmem}  | (jail) :: parameter of kmem CBSD |
|${allow_mount} | (jail) :: parameter of jail(8) |
|${allow_nullfs}| (jail) :: parameter of jail(8) |
|${allow_procfs}| (jail) :: parameter of jail(8) |
|${allow_reserved_ports} | (jail) :: parameter of jail(8) |
|${allow_sysvipc} | (jail) :: parameter of jail(8) |
|${allow_tmpfs} | (jail) :: parameter of jail(8) |
|${allow_zfs} | (jail) :: parameter of jail(8) |
|${applytpl} | (jail) :: parameter of applytpl CBSD |
|${arch} | (jail) :: arch of containers |
|${astart} | (jail, bhyve, xen) :: a sign of auto-start of the environment |
|${b_order} | (jail, bhyve, xen) :: order/priority (weight) of environment launch |
|${basename} | (jail) :: name of the base for containers |
|${baserw} | (jail) :: parameter of baserw CBSD |
|${bhyve_flags} | (bhyve) :: additional flags for bhyve |
|${bhyve_force_msi_irq} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_generate_acpi} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_ignore_msr_acc} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_mptable_gen} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_rts_keeps_utc} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_vnc_resolution} | (bhyve) :: VNC server resolution in 1024x768 format |
|${bhyve_vnc_tcp_bind} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_vnc_tcp_ipconnect} | (bhyve) :: IP address for connecting a VNC client |
|${bhyve_wire_memory} | (bhyve) :: parameter of bhyve(8) |
|${bhyve_x2apic_mode} | (bhyve) :: parameter of bhyve(8) |
|${cd_vnc_wait} | (bhyve) :: parameter of bhyve(8) |
|${childrenmax} | (jail) :: parameter of jail(8) |
|${cpuset} | (jail, bhyve, xen) :: to which processor cores the environment is attached |
|${data} | (jail) :: actual container data path |
|${devfs_ruleset} | (jail) :: parameter of jail(8) |
|${emulator} | (jail, bhyve, xen) :: name of the engine for virtualization/containirisation |
|${emulator_flags} | (jail) :: flags for qemu |
|${enforce_statfs} | (jail) :: parameter of jail(8) |
|${exec_consolelog} | (jail) :: parameter of jail(8) |
|${exec_fib} | (jail, bhyve, xen) :: applied routing table |
|${exec_master_poststart} | (jail, bhyve, xen) :: scripts for master_poststart |
|${exec_master_poststop} | (jail, bhyve, xen) :: scripts for master_poststop |
|${exec_master_prestart} | (jail, bhyve, xen) :: scripts for master_prestart |
|${exec_master_prestop} | (jail, bhyve, xen) :: scripts for master_prestop |
|${exec_poststart} | (jail) :: scripts for poststart |
|${exec_poststop} | (jail) :: scripts for poststop |
|${exec_prestart} | (jail) :: scripts for prestart |
|${exec_prestop} | (jail) :: scripts for prestop |
|${exec_start} | (jail) :: scripts for start |
|${exec_stop} | (jail) :: scripts for stop |
|${exec_timeout} | (jail) :: parameter of jail(8) |
|${floatresolv} | (jail) :: parameter of baserw CBSD |
|${hidden} | (jail, bhyve, xen) :: visibility in the WEB interface |
|${host_hostname} | (jail) :: parameter of jail(8) |
|${interface} | (jail, bhyve, xen) :: to which network interface is the environment bound |
|${ip4_addr} | (jail, bhyve, xen) :: the list of IP addresses of the environment specified in CBSD (comma separated) |
|${maintenance} | (jail, bhyve, xen) :: service mark |
|${mdsize} | (jail) :: the volume of the jail image, if jail is in the md-backend image |
|${mkhostsfile} | (jail) :: control of contents /etc/hosts |
|${mount_devfs} | (jail) :: parameter of jail(8) |
|${mount_fdescfs} | (jail) :: parameter of jail(8) |
|${mount_fstab} | (jail) :: fstab file for the jail |
|${mount_kernel} | (jail) :: mount kernel dir in jail? |
|${mount_obj} | (jail) :: mount obj dir in jail? |
|${mount_ports} | (jail) :: mount /usr/ports dir in jail? |
|${mount_src} | (jail) :: mount /usr/src dir in jail? |
|${nic_hwaddr} | (jail, bhyve, xen) :: MAC address of the virtual interface |
|${path} | (jail) :: root jail in the host file system |
|${persist} | (jail) :: parameter of jail(8) |
|${protected} | (jail, bhyve, xen) :: a sign of protecting the environment from uninstallation via the remove command |
|${stop_timeout} | (jail) :: timeout of soft container stop |
|${ver} | (jail) :: FreeBSD base version for jail |
|${virtio_type} | (bhyve) :: type of disk controller |
|${vm_cpus} | (bhyve, xen) :: number of guest virtual cores |
|${vm_hostbridge} | (bhyve, xen) ::  |
|${vm_iso_path} | (bhyve, xen) :: |
|${vm_os_profile} | (bhyve, xen) :: |
|${vm_ram} | (bhyve, xen) :: amount of guest RAM |
|${vm_rd_port} | (jail, bhyve, xen) :: |
|${vm_vnc_port} | (bhyve, xen) :: VNC port |
|${vnc_password} | (jail, bhyve, xen) :: VNC password |
|${vnet} | (jail) :: vnet enabled jail? |
|${ipv4_first_public} | (jail, bhyve) :: first public IPv4 address of the environment |
|${ipv4_first_private} | (jail, bhyve) :: first private IPv4 address of the environment |
|${ipv4_first} | (jail, bhyve) :: first (any) IPv4 address of the environment |
|${ipv6_first_public} | (jail, bhyve) :: first public IPv6 address of the environment |
|${ipv6_first_private} | (jail, bhyve) :: first public IPv6 address of the environment |
|${ipv6_first} | (jail, bhyve) :: first (any) IPv6 address of the environment |

