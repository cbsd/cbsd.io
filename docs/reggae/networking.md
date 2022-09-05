# Networking scenarios

By default `reggae network-init` will set up configuration for desktop/laptop
environment. If you need router or server with similar capabilities, there are
only few things to change.

## Router
Just add interface(s) to bridge:

```sh
ifconfig cbsd0 addm re0
```

To make it permanent, just append `addm re0` to the `ifconfig_cbsd0=...` line in
`/etc/rc.conf`.

## Server
Add interface to bridge (like for router) and stop/destroy `network` jail. The
difference compared to router is that the interface you add to bridge is egress
so check `/etc/pf.conf` for comments about adding egress to bridge. Also, any
configuration you have for egress interface should be removed and bridge
interface should have IP address that egress had. For example, if you had
`ifconfig_re0="inet 192.168.0.2/24"` before, it should be changed to
`ifconfig_re0="up"` and `ifconfig_cbsd0="inet 192.168.0.2/24 <the rest of the options>"`. 
