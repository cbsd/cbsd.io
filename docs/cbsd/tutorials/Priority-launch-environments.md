# Priority launch environments

**Commands: jorder, jorder-tui, border, border-tui**

```
% cbsd jls display=jname,b_order
```

**Description:**

Sometimes a **jail/vm** will require an already running service from another machine/jail before it is launched. Examples might be a database **SQL** or a running **LDAP**.

In this case, you can edit **Boot Order** (***b_order in jail/vm settings***)

By default, all environments are created with ***b_order*** set to **10** (which is defined in the profile and can be changed)

If you need **jail2** to be launched before jail1, its value for b_order must be set to a lower one than that of the second jail.

You can display the current configuration with the command **jls**:

```
% cbsd jls display=jname,b_order
JNAME    B_ORDER
firefly  3
jail1    10
kde4     1
kdeold   9
spicy2   2
test     2
```
This sample configuration will launch **kde4** first while **jail1** will come up last

You can also display the sequence using the command **jorder**

```
% cbsd jorder
```
In what sequence jail printer - in this sequence they will run

To edit a launch sequence use **jset** or the TUI-editor **jorder-tui**

To edit bhyve priority, use the commands **border** or **border-tui**

![](img/jorder1.png)


![](img/jorder2.png)
