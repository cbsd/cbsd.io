# Searching for jail in node farm

**jwhereis, jailmapdb commands**

```
% cbsd jwhereis
% cbsd jailmapdb
```
**Description:**

Should you manage more than one FreeBSD/cbsd node farm, you can generate a map with jail locations refering to the appropriate servers. The utility `jlogin` is used in order to search remote jails. This map can be used for a variety of tools, such as a custom admin panel, automatically documentating the farm, as well as a variety of services.

For example, a Bacula jail can automatically search the map for new jails and create configuration for their backup; or when a jail migrates from one physical node to another the target host can be reconfigured with jails for backup without the need for manual interaction by the system administrator.
