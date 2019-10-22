# Adding nodes

**node mode=add command**

```
% cbsd node mode=add
```

Commands **cbsd node mode=add** .., at availability of the remote node via ssh and the correct password of the user **CBSD**, takes away a private key from the remote server and save it in the catalog `$workdir/.rssh`

Obligatory parameters for mode=add:

* **node** = IP address or FQDN of server (in the list of notes, however, this server will be called how is specified in nodename on the remote node in `$workdir/nc.inventory`. This that name which is asked at the first start **cbsd initenv**
* **pw** = password for CBSD user

Unessential argument:

* **port** = alternative number of sshd port. By default, nodes of **CBSD** use port 22222 for connection on SSH.

```
*** Attention: the password of CBSD user is used only at the moment of receiving a private key. Respectively, access on the server will be until the key won't be removed or re-generated. Change of the password of the user account in this case won't work.
```

**Example:**

```
% cbsd node mode=add node=192.168.1.2 pw=superpw port=22
```
![](img/nodeadd1.png)
