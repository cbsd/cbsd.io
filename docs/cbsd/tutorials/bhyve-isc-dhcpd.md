# CBSD/bhyve and ISC-DHCPD

## Example of using CBSD/bhyve and ISC-DHCPD

This article demonstrates some uses **CBSD master/pre/post** to integrate the CBSD with external services.

If you read the description of the functional master/pre/post hooks, then this feature allows you to embed the execution of custom scripts in different Stage of life of the virtual environment. At the same time, in these scripts, the values of variables of this environment are available, so you can identify Events with a specific environment and/or use these parameters for some of their purposes.

One of the tasks that you need to solve when working with virtual environments is to manage the network settings inside the virtual machine.

This is not very difficult if you have your own virtual environment image, in which you can embed your own scripts (for example, so works vm_obtain method in [ClonOS](https://clonos.tekroutine.com/)), or work with a virtual machine through the virtio-console. But this method is not suitable if:

* You install the virtual machine from scratch using the ISO image obtained from the developer site;
* You use a large number of completely different distributions, each with its own method of initializing network settings;

In this case, the most universal method, suitable for any OS, is the use of the standard protocol for initializing network settings [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol).

Let's try, with the example of this task, to show how you can use the master/pre/post hook function when working with virtual environments, using **isc-dhcpd** in conjunction with CBSD for control IP address in bhyve.

Instead of isc-dhcpd, any other DHCP server can be used, for example [DNSMasq](http://www.thekelleys.org.uk/dnsmasq/doc.html), workflow will be approximately the same:

**DHCPD** server allows you to configure the network subnet. In addition, you can fix pairs MAC address and IP. In other words, knowing a particular MAC address, you configure the DHCPD server to give it a fixed, predefined IP address.

CBSD knows MAC addresses, So our goal is somewhere in the container launch phase, configure DHCP to issue an IP address that we'll point to CBSD for the MAC address that the virtual environment will give out (or we'll assign) to it.

Schematically, the flowchart should work for you about this:

![](img/cbsd_bhyve_dhcpd.png)

We assume that CBSD already installed and configured, and its version is not lower than 11.0.10

1) Install isd-dhcpd package via [pkg](http://man.freebsd.org/pkg/8):

```
% pkg install net/isc-dhcp44-server
```
or from the ports:

```
% env BATCH=no make -C /usr/ports/net/isc-dhcp44-server
```

2) The next step is to define the network that will be used in the automatic configuration and writing the corresponding configuration block file for DHCP. Let's say our network will be 198.168.0.0/24, DNS take from Google, and default gateway is 192.168.0.1:

Create directory /root/etc for config file:

```
% mkdir /root/etc
```

And put in the directory file /root/etc/dhcpd.conf with the initial configuration. It can look like this:

```
option domain-name "example.com";
option domain-name-servers 8.8.8.8,8.8.4.4;
option subnet-mask 255.255.255.0;
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.0.0 netmask 255.255.255.0 {
        range 192.168.0.2 192.168.0.254;
        option broadcast-address 192.168.0.255;
        option routers 192.168.0.1;
}

```
By this we have designated the network for which dhcpd.

Unfortunately, at the time of this writing, the dhcpd.conf configuration file does not support the ability to include separate configuration files or specify directories with an extra configuration (or the author did not look well), so we need a script, which will manage the second part of the dhcpd.conf configuration file, adding at the start of the virtual machine record the correspondence of the IP address and the MAC for the first network interface of the guests.

We will know the MAC address and IP address on the stage master/pre/post CBSD. In addition, so that we do not have duplicates with records, records to a particular virtual machine are identified by some sign (for example, in a comment), by which we will find old records and delete before adding a new one. For this purpose, we also need a variable `$jname`.

So, at the input we will receive three parameters - the name of the virtual environment, the physical address (MAC) of the first interface and the IP address. At the output - we add in /root/etc/dhcpd.conf bind the address and MAC and reload the dhcpd daemon. At the end of the script, reboot dhcpd to apply the new configuration.

Write a script:

```
#!/bin/sh
DHCPD_CONF="/root/etc/dhcpd.conf"

# fatal error. Print message then quit with exitval
err() {
        exitval=$1
        shift
        echo "$*" 1>&2
        exit $exitval
}

[ -z "${jname}" ] && err 1 "no jname variable"
[ -z "${nic_hwaddr0}" ] && err 1 "no nic_hwaddr0 variable"
[ -z "${ip4_addr}" ] && err 1 "no ip4_addr variable"
[ ! -r "${DHCPD_CONF}" ] && err 1 "no ${DHCPD_CONF}"

# Remove old records for this host if exist
if grep "CBSD-AUTO-${jname}" ${DHCPD_CONF} >/dev/null 2>&1; then
	/bin/cp -a ${DHCPD_CONF} /tmp/dhcpd.tmp.$$
	trap "/bin/rm -f /tmp/dhcpd.tmp.$$" HUP INT ABRT BUS TERM EXIT
	grep -v "CBSD-AUTO-${jname}" /tmp/dhcpd.tmp.$$ > ${DHCPD_CONF}
fi

# Insert new records into config file
printf "host ${jname} { hardware ethernet ${nic_hwaddr0}; fixed-address ${ip4_addr}; } # CBSD-AUTO-${jname}\n" >> ${DHCPD_CONF}

service isc-dhcpd restart
```
And put it in the catalog /root/bin as /root/bin/make_cbsd_dhcpd.sh:

In order for DHCPD to run along with the system, we activate it through rc.conf. Also, we specify an alternative path to the configuration file /root/etc/dhcpd.conf: Also, it is desirable to specify the interface on which DHCPD will serve virtual machines. In my case, bhyve machines will be launched by default - creating a tap interface that will be bridged to the uplink interface. On my server is a network interface em0:


```
% sysrc dhcpd_enable="YES"
% sysrc dhcpd_ifaces="em0"
% sysrc dhcpd_conf="/root/etc/dhcpd.conf"
```

```
*** Attention! *** Be careful if you run DHCPD on a connected physical interface. Because your server will give out addresses not only to virtual bhyve environments, but also all other devices in your network, if they ask them. Moreover, if there is another DHCPD server on your network, you can also disrupt it.

To avoid this, simply block network traffic from the ports on which dhcpd is on the outside. If the interface - em0, it is possible, for example, via ipfw:
```

```
/sbin/ipfw add 5000 deny tcp from me to any dst-port 67-68 via em0 out
/sbin/ipfw add 5001 deny udp from me to any dst-port 67-68 via em0 out

/sbin/ipfw add 5000 deny tcp from any to not me dst-port 67-68 via em0 in
/sbin/ipfw add 5001 deny udp from any to not me dst-port 67-68 via em0 in
```
Another method of solving - you can specify dhcpd to work only on those (tapX) interfaces, which are created when the virtual machine starts.

Well. All elements are ready, it remains only to connect them.

We will need master_prestart hook, because we need to perform the actions on the host system and at the moment preceding directly launching the virtual machine. It is **master_prestart.d** directory in system personal catalog for VM: $workdir/jail-system/$jname

where:

* `$workdir` - Path with which it was initialized CBSD (usual /usr/jails)
* `$jname` - name of virtual applicane, for example: freebsd1

To ensure the launch of hooks, we just need to put the executable script inside the corresponding directory. This is easy if you have 1-2 permanent environments. What if you plan to have more virtual machines and more, Do you plan to delete and create them often enough? We will always have to remember the need to put a script.

Let's slightly complicate the task, but we will make our life easier in the future, shifting another problem to automation.

To do this, we use profiles CBSD, and in particular, we will not even create a separate profile for our DHCP machines, It is enough to reassign the path where to take directories with hooks in the default template.

Create /root/share directory, where we will store alternative content of system-directories for newly created environments:

```
% mkdir /root/share
```
Copy the standard directory tree from the distribution CBSD, it does not contain any scripts:

```
% cp -a ~cbsd/share/jail-system-default /root/share
```

Perhaps, the script that adds records to dhcpd.conf is quite versatile and we do not need to copy it to each created environment. We will dispense with symbolic links that will point to it. To do this, go to the **master_prestart.d** directory, template and specify [ln](http://man.freebsd.org/pkg/1)to the source script:

```
% cd /root/share/jail-system-default/master_prestart.d
% ln -sf  /root/bin/make_cbsd_dhcpd.sh
```
And will reassign the path to the skel-directory to our copy, through the configuration file ~cbsd/etc/bhyve-default-default.conf, parameters in which will overwrite file parameters of ~cbsd/etc/defaults/bhyve-default-default.conf

```
echo 'systemskeldir="/root/share/jail-system-default"' > ~cbsd/etc/bhyve-default-default.conf
```

That's all! We can only run [cbsd bconstruct-tui](bhyve-virtual-machine.md) and to stamp virtual machines with the specified IP addresses in the configuration ip4_addr.

Please note that on the interface where you start **DHCPD** (in our case it's the em0 interface, you must have at least one IP address from the subnet that is distributed through DHCPD

Since in our case the default gateway is this server, we simply assigned the 192.168.0.1 address as an alias to em0.

## CBSD/bhyve and PXE boot: bhyve vm diskless boot over PXE/Bootp

Since 11.0.12 version, CBSD supports the ability to load bhyve virtual machines via PXE protocol.

In order to activate bhyve PXE boot, use vm_boot menu to select options: 'net' boot device

![](cbsd_bhyve_pxe1.png)

Next, we will need to modify the script from the first part of the article so that for some servers we could use additional configuration lines in dhcpd.conf that relate to the PXE/bootp boot protocol. Such as:

```
filename "filename"
option root-path "nfspath"
```

In order not to "hard-code" PXE parameters individually to different virtual machines, let's agree to have in the system environment directory ( $workdir/jails-system/$jname ) a file, in the presence of which, all of its contents will be paste as-is to the block in dhcpd.conf:

```
host $jname {
     ...
     // custom settings //
     ...

   }
```

Thus, we make our hook script more flexible, because we can now enter any dhcpd settings for a particular virtual machine in a file that always lies in the hierarchy of the system directories of the given environment. This allows us not to lose this file when cloning, importing-exporting and so on. Let it be a file named: dhcpd_extra.conf

Superior script would look like in the following way:

```
#!/bin/sh
# Helper for integration CBSD/bhyve and isc-dhcpd
# We assume bhyve have correct 'ip4_addr' settings
# To add dhcpf.conf extra-config (e.g. bootp-related) for
#    hosts ${jname} {  ..  }
#    please use file in ${jailsysdir}/${jname}/dhcpd_extra.conf
#    << all content from this file will be dropped to { } block
#
DHCPD_CONF="/root/etc/dhcpd.conf"

. /etc/rc.conf

workdir="${cbsd_workdir}"

set -e
. ${workdir}/cbsd.conf
. ${workdir}/nc.subr
set +e

export NOCOLOR=1

# $1 - ip test
# return 0 if ip4
# return 1 if ip6
# return 2 if DHCP
# return 3 if unknown
ip_type()
{
	case "${1}" in
		*\.*\.*\.*)
			return 0
			;;
		*:*)
			return 1
			;;
		[Dd][Hh][Cc][Pp])
			return 2
			;;
		*)
			return 3
			;;
	esac
}

[ -z "${jname}" ] && err 1 "no jname variable"
[ -z "${nic_hwaddr0}" ] && err 1 "no nic_hwaddr0 variable"
[ -z "${ip4_addr}" ] && err 1 "no ip4_addr variable"
[ ! -r "${DHCPD_CONF}" ] && err 1 "no ${DHCPD_CONF}"

EXTRA_CONF="${jailsysdir}/${jname}/dhcpd_extra.conf"

ip_type ${ip4_addr}

ret=$?

case "${ret}" in
	0)
		echo "IPv4 detected"
		;;
	1)
		echo "IPv6 detected"
		;;
	2)
		# Fake DHCP - we need learn to get IPS from real dhcpd (tap iface + mac ?)
		tmp_addr=$( /usr/local/bin/cbsd dhcpd )
		ip4_addr=${tmp_addr%%/*}
		# check again
		ip_type ${ip4_addr}
		ret=$?
		case "${ret}" in
			0|1)
				# update new IP
				cbsd bset ip4_addr="${ip4_addr}" jname="${jname}"
				;;
			*)
				err 0 "Can't obtain DHCP addr"
				;;
		esac
		;;
	*)
		err 0 "Unknown IP type: ${ip4_addr}"
		;;
esac

# Remove old records for this host if exist
if grep "CBSD-AUTO-${jname}" ${DHCPD_CONF} >/dev/null 2>&1; then
	/bin/cp -a ${DHCPD_CONF} /tmp/dhcpd.tmp.$$
	trap "/bin/rm -f /tmp/dhcpd.tmp.$$" HUP INT ABRT BUS TERM EXIT
	grep -v "CBSD-AUTO-${jname}" /tmp/dhcpd.tmp.$$ > ${DHCPD_CONF}
fi

# Insert new records into config file
cat >> ${DHCPD_CONF} <<EOF
host ${jname} {					# CBSD-AUTO-${jname}
	hardware ethernet ${nic_hwaddr0};	# CBSD-AUTO-${jname}
	fixed-address ${ip4_addr};		# CBSD-AUTO-${jname}
EOF

if [ -r "${EXTRA_CONF}" ]; then
	echo "Found extra conf: ${EXTRA_CONF}"
	cat ${EXTRA_CONF} |while read _line; do
		cat >> ${DHCPD_CONF} <<EOF
	${_line}				# CBSD-AUTO-${jname}
EOF
	done
fi

cat >> ${DHCPD_CONF} <<EOF
}				# CBSD-AUTO-${jname}
EOF

arp -d ${ip4_addr}
arp -s ${ip4_addr} ${nic_hwaddr0} pub

service isc-dhcpd restart

```

And we put this script instead of the old one /root/bin/make_cbsd_dhcpd.sh

Now, we can create dhcpd_extra.conf file in the system catalogs of virtual machines that will be loaded on the PXE, where the main role will be played by parameters such as:

```
     filename "FreeBSD/install/boot/pxeboot" ;
     option root-path "192.168.0.1:/b/tftpboot/FreeBSD/install/" ;
```

The rest of the configuration is a trivial configuration of tftpboot and NFS services, giving you the files you need.

You can find a lot of articles about configuring the PXE server on the Internet, as well as on the official website FreeBSD: the Handbook entry on diskless booting.

Either, you can do this in the steps below. These commands were used to create a PXE boot, demonstrated in this short demo:

* Bhyve unattended installation with CBSD: PXE and cloud-init

In this example, our server IP address has: 192.168.0.2 and we boot the PXE environment, copied from the installation ISO FreeBSD 11.0-R media/distribution

```
% mkdir /FreeBSD
% wget https://download.freebsd.org/ftp/releases/amd64/amd64/ISO-IMAGES/11.0/FreeBSD-11.0-RELEASE-amd64-disc1.iso
% mount_cd9660 /dev/`mdconfig -a -t vnode -f ./FreeBSD-11.0-RELEASE-amd64-disc1.iso` /mnt
% cp -a /mnt/* /FreeBSD/
% umount /mnt
% mkdir /root/etc
% cat > /root/etc/inetd.conf <<EOF
tftp   dgram   udp     wait    root    /usr/libexec/tftpd      tftpd -l -s /FreeBSD
tftp   dgram   udp6    wait    root    /usr/libexec/tftpd      tftpd -l -s /FreeBSD
EOF

% echo "/FreeBSD -ro -alldirs" > /etc/exports
% echo "192.168.0.2:/FreeBSD /mnt nfs rw 0 0" > /FreeBSD/etc/fstab

% sysrc inetd_enable="YES"
% sysrc inetd_flags="-wW -C 60 /root/etc/inetd.conf"
% sysrc nfs_server_enable="YES"
% sysrc mountd_enable="YES"

% service nfsd restart
% service mountd restart
% service inetd restart
```

On this download bhyve by PXE is ready. It remains to create a virtual machine, in 'cbsd bconfig' change the boot method to: 'net'
And write extra-settings for this virtual machine in a file dhcpd_extra.conf

For example, if your `$workdir` is - `/usr/jails`, and you configure PXE to boot the virtual machine with the name freebsd1, then in the catalog /usr/jails/jails-system/freebsd1 should be dhcpd_extra.conf file with follow content:

     filename "loader.efi" ;
     option root-path "192.168.0.2:/FreeBSD/" ;

