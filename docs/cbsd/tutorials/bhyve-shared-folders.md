# Bhyve shared folders via virtio-p9

**Commands bhyve-p9shares**

```
% cbsd bhyve-p9shares
```

**Description:**

***This feature available from **CBSD 11.1.7** and above.***

Shared folders are used to exchange files between virtual machines or between a virtual machine and a host system.

This feature works only if your system supports VirtFS/[P9](https://en.wikipedia.org/wiki/9P_(protocol)) and **bhyve** support **virtio-p9**.

At the time of writing this article (2017-10-01), such a system is **TrueOS**, whereas for FreeBSD a patch is prepared and loaded into **Phabricator**:[D10335](https://reviews.freebsd.org/D10335)

In addition, working with shared folders will only be available if your guest OSs have support for mounting the p9 file system via virtio.

To configure shared folders, you need to have the directory to share on on the file system, which will be presented to the virtual machine and sets name (one word) for this resources for guest OS.

To view existing shared folders, use the command:

```
% cbsd bhyve-p9shares mode=list

JNAME    P9PATH       P9DEVICE
f111     /root        root
debian1  /tmp/share1  share1
debian1  /tmp/share2  share2
```
Or for an individual virtual machine:

```
% cbsd bhyve-p9shares mode=list jname=XXX
```
To enable shared folders for a specific virtual machine, use **mode=attach** with **p9path,p9device** arguments to specify a directory and a shared resource name, e.g:

```
% cbsd bhyve-p9shares mode=attach p9device=share1 p9path=/tmp/share1 jname=debian1
```

To disable shared folders for a specific virtual machine, use **mode=detach** with **p9device** argument.

After running the virtual machine, you can connect shared folders in different ways, depending on the specific distribution. For example, in a Debian-based Linux distribution, this is done through a **9mount** package and this command:

```
% mount -t 9p -o trans=virtio sharename /mnt
```
or

```
% 9mount -i 'virtio!sharename' /mnt
```
![](img/bhyve-p9fs1.png)

bhyve shared folders via VirtFS/virtio-p9:

<script type="text/javascript" src="https://asciinema.org/a/140432.js" id="asciicast-140432" async></script>
