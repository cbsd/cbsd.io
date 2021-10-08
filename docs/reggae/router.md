# Convert Reggae Installation to Router

## Host
```
cbsd jstop cbsd
cbsd jset jname=cbsd 'ip4_addr=cbsd0#172.16.222.253,fe80:1::dead:beef:1/64,re0#192.168.222.3'
cbsd jstart cbsd
```

/var/unbound/zones/example.com.zone:
```
example.com. SOA example.com. hostmaster.example.com. (
                  1998092901  ; Serial number
                  60          ; Refresh
                  1800        ; Retry
                  3600        ; Expire
                  1728 )      ; Minimum TTL
example.com.            NS      example.com.

$ORIGIN example.com
@          A   192.168.222.2
```

/var/unbound/conf.d/example.com.conf:
```
auth-zone:
    name: "example.com"
    zonefile: "zones/example.com.zone"
```

/var/unbound/unbound.conf:
```
server:
    verbosity: 1
    username: unbound
    directory: /var/unbound
    chroot: /var/unbound
    pidfile: /var/run/local_unbound.pid
    auto-trust-anchor-file: /var/unbound/root.key
    root-hints: /var/unbound/root.hints
    interface: 127.0.0.1
    interface: 172.16.220.254
    interface: 172.16.222.254
    interface: 192.168.222.2
    access-control: 0.0.0.0/0 allow_snoop
    val-permissive-mode: yes

include: /var/unbound/forward.conf
include: /var/unbound/lan-zones.conf
include: /var/unbound/control.conf
include: /var/unbound/conf.d/*.conf
```

## CBSD Jail
/usr/local/etc/dhcpd.conf:
```
subnet 192.168.222.0 netmask 255.255.255.0 {
  option domain-name "example.com";
  option domain-name-servers 192.168.222.2;
  range 192.168.222.100 192.168.222.254;
  option routers 192.168.222.1;
  option broadcast-address 192.168.222.255;
  default-lease-time 28800;
  max-lease-time 36000;
  on commit {
    set clientIP = binary-to-ascii(10, 8, ".", leased-address);
    set clientHost = pick-first-value(option fqdn.hostname, option host-name, "");
    execute("/usr/local/bin/dhcpd-hook.sh", "add", clientIP, clientHost, "example.com");
  }
  on release {
    set clientIP = binary-to-ascii(10, 8, ".", leased-address);
    set clientHost = pick-first-value(option fqdn.hostname, option host-name, "");
    execute("/usr/local/bin/dhcpd-hook.sh", "delete", clientIP, clientHost, "example.com");
  }
  on expiry {
    set clientIP = binary-to-ascii(10, 8, ".", leased-address);
    set clientHost = pick-first-value(option fqdn.hostname, option host-name, "");
    execute("/usr/local/bin/dhcpd-hook.sh", "delete", clientIP, clientHost, "example.com");
  }
}
```

/etc/rc.conf.d/dhcpd:
```
dhcpd_enable="YES"
dhcpd_flags="-q"
# dhcpd_ifaces="cbsd0"
dhcpcd_ifaces="cbsd0 re0"
dhcpd_conf="/usr/local/etc/dhcpd.conf"
dhcpd_withumask="022"
dhcpd_withgroup="unbound
```
