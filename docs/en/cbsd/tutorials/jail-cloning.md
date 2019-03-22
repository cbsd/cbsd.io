# Jail cloning

**jclone command**

```
% cbsd jclone

% cbsd jrclone
```

**Description:**

Creates a clone of a given jail. The command requires the name of the original jail (passed with **old**) as well as a name for the clone, specified with **new** and a FQDN (hostname) with **host_hostname**. Optionally a new IP Address can be given with the **ip4_addr** parameter (multiple IPs need to be separated by commas).

```
*** Attention ***: Since 11.0.10 version, CBSD on ZFS-based hosters will be use ZFS clone features!

```

ZFS clone features is ultra fast operation (thanks to Copy-on-write), but imposes some restrictions - you will be dependent on the parent snapshot. If you try to remove parent environment, CBSD automatically executes the **zfs promote** command, but when you works with snapshot independently - just keep it in your mind

You can control this behaviour via **clone_method=** argument or, to set it globally, use *rclone.conf* and *bclone.conf* to overwrite settings from 'auto' to 'rsync':

```
% echo 'clone_method="rsync"' > ~cbsd/etc/rclone.conf
% echo 'clone_method="rsync"' > ~cbsd/etc/bclone.conf
<pre>       <p>When <i>~cbsd/etc/bclone.conf</i> (for bclone) and <i>~cbsd/etc/rclone.conf</i> contain:
</p><pre>       clone_method="rsync"
</pre>
<p>Clone will not use zfs clone even on ZFS filesystem and you will get full copy via rsync</p>
<p><strong>Example:</strong></p>
<p>cloning jail jail2 to jail3 with changes ip address <strong>ip4_addr</strong> and name of hosts <strong>host_hostname</strong>:</p>
<pre class="brush:bash;ruler:true;">            % cbsd jclone old=jail2 new=jail3 host_hostname=jail3.my.domain ip4_addr=10.0.0.22/24
</pre>
<p class="text-center"><img src="/img/jclone1.png" alt=""></p>
</pre>
```
