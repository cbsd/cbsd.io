# Removal nodes

**node mode=remove command**

```
% cbsd node mode=remove
```

The commands **cbsd node mode=remove node=nodename** delete private key and records for this node from the `$workdir/.rssh` directory. The name specified in node= should coincide with that writing which is output on **cbsd node mode=list**

Example:

```
% cbsd node mode=remove node=backup1.mydomain.ru
```
