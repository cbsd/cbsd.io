# Jail renaming

**jrename command**

```
% cbsd jrename
```
**Description:**

Renames a jail and modifies all relevant according to the new name. The command can only be executed on stopped jails.

jrename has the two following mandatory parameters:

*  **old** — old name of the jail
*  **new** — new name of the jail

Optional parameters:

* **host_hostname** — FQDN, new full hostname of jail
* **ip4_addr** — new IP address of the jail (if multiple IPs, separated by a comma with no spaces)

**Example** (renaming jail **jail1** into **jail50** with a FQDN and ip addresses change):

![](https://www.bsdstore.ru/img/jrename1.png)
