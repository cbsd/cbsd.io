 Encrypting images with  cbsd geli

There are situations where the information posted on the server's hard drive should preferably be stored in encrypted form. For example, you are setting up a server with important information in any foreign datacenter . There are real cases (author familiar with the case not by hearsay ) when disgruntled employees datacenter can take a few minutes to turn off your server , under any pretext ( breaks technical work — not uncommon) , make an image of the hard drive and turn back , that you will look like rebooting the server , while all the information is from third parties became individuals. Either you rent VDS / VPS, where a stranger to you, not only the data center , but also the server and media.

In such cases, resort to encrypt that data leakage which is undesirable. Currently, **CBSD** has a script wrapper **geli** working with encrypted images through GELI framework. As well as before using cbsd is highly desirable to get acquainted with  original man for  [jail](http://www.freebsd.org/cgi/man.cgi?query=jail&sektion=8), and in this context, it is strongly recommended to read the following information:

+ [man geli](http://www.freebsd.org/cgi/man.cgi?query=geli&sektion=8)
+ paragraph 18.14.2 B [Encrypting Disk Partitions](http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/disks-encrypting.html)

Before using **cbsd geli**.

Working with GELI assumed the following scenario:

+ Encryption be only selected data. Since the encryption operation is dependent primarily on your CPU resource consumption will always be higher , and I/O — lower than when working with data on the encrypted partition. Instead of encrypting the entire jail, you can choose to encrypt only important path inside the jail, for example: `/root, /home/user, /var/db/mysql, /usr/local/etc` etc, while the logs, database, or all of the third party software that you installed via pkg/ports — can be left unencrypted. Also, besides the encryption of these jails, you may want to encrypt the directory ` $workdir/.rssh`, which keeps cbsd ID_RSA keys remote machines and `$workdir/.ssh` which is your own key to the user cbsd.

+ Each encrypted device is assigned their own password/passphrase to decrypt. However, they will all be stored on the system image of **CBSD**, which in turn will be encrypted master- key. In other words, as you trust your own server, if necessary, to include one or another encrypted partition, **CBSD** itself will apply the correct key when using of encrypted image. At the same keys for their decryption is stored in a file, which in turn is encrypted with your password and activated manually.

For common understanding, we denote the following conventions:

+ **${dbdir}**— directory `$workdir/var/db`, where workdir — is path to initialized of **CBSD**. For example: `/usr/jails/var/db`
+ **MASTER_GELI** - your password encrypted image, which **CBSD** will look for clues to the rest geli attach operations. Located on the file system as a file `${dbdir}/master_geli.img`

          Attention! Removing or defacing this file would make it impossible to connect all remaining crypted images automatically and mount these images will only be possible if you remember what the image which password you assigned to the  cbsd geli mode=init file= stage. In this regard, make regular backups of the file.

+ **key directory**— mounted image of **MASTER_GELI** file into `${dbdir}/geli` directory. To avoid possible damage due to incorrect unmount (server failure, loss of power, improper shutdown), the resource is connected in Read-only mode and re-mount in rw only for modifications.

## cbsd geli initialization

To start working with an encrypted partition on the node, you must create **MASTER_GELI** file and come up with a password for it. Use a strong password, because it gives access to all other keys. To use the command of initialization: **cbsd geli mode=initmaster**.


```
% cbsd geli mode=initmaster
Initialization. Please set master password for geli base image
Enter new passphrase:
```

Secondary running this command will give the question to enter the password, or the command will work without any output, if the file already initialized and mounted automatically at `$dbdir/geli`. Successful initialization file contents of the file mounted to the directory `$dbdir/geli`, let the rest of the scripts access to keys for other images.

*Note:

By default, the image is created for storage of keys equal to 5Mb with AES-XTS algorithm. This setting is in the file `${workdir}/etc/defaults/geli.conf` and can be changed via the corresponding entries in  `$workdir/etc/geli.conf`*

## Initialization geli-images for CBSD use

GELI Initialization of image should be before you start it up and mounting the write data. To initialize, use the command:

```
% cbsd geli mode=init file=/path/to/file
```

When you first start geli init file /path/to/file will perform the following steps:

+ 1) if path begins with $workdir (eg, **CBSD** installed in /usr/jails, and cbsd init executed with settings **mode=init file=/usr/jails/jails-system/jail1/root.img**), then logic of script path $workdir removed out of the way and this location is used to generate key file name via md5. Such an operation is needed for those cases, if you migrate from one jail to another node and various $workdir — if not cut workdir, then md5 key names will be different. If the path is a file that is not in $workdir, the path remains unchanged.
+ 2) **cbsd geli** script prompts you to password for the file in the file = variable and stores it in a file `$dbdir/geli/md5_from_result_of_step_1`
+ 3) Executing of geli attach with this key, and displays the name of the resulting device, such as:

```
/dev/md1.eli
```
 you can already format and fill the data that will be encrypted.

As is the case with initmaster, if you start a second init file — the system without question it presents, if the key already exists.

Schematically, the interaction with **CBSD** GELI script with the system looks like this:

![](img/cbsd_geli1.png)

## Using jails fstab to list of crypted images and   mount points

For example, that jail *jail1* on startup mount crypted image in directory `/usr/home/web` inside the environment, on the local fstab file of jails stored the name of the image file and the file system type sets to geli, for example:

```
webhome.img /usr/home/web geli rw 0 0
```

In this case, the file webhome.img must me store in the directory /usr/jails/jails-system/jail1/ (when workdir = /usr/jails).

If you store the crypto image is not in `/usr/jails/jails-system/$jname/` directory, it is necessary to prescribe the full path starting with /. for example:

```
/data/images/webhome.img /usr/home/web geli rw 0 0
```
However, storage for .img files of jails `/usr/jails/jails-system/$jname/` is recommended, because the directory `jails-system/$jname` participates in the operations of migration, **jimport** and **jexport**. Otherwise, you will have to carry their own image file.


Keep in mind, when after booting server you have no init the **CBSD** geli (cbsd geli mode=initmaster), which after the password has access to the keys to decrypt the images and jails is starting, **CBSD** can not find a key to decrypt the image and the crypto directory is not be mounted. Therefore, as a rule, crypto jails should have a flag autostart is off(**astart=0**).

## A practical example

Suppose we have a jail named **private1**, wherein the base files, configuration, and third party software installed from ports we encrypt is not required, since all this so you can download on the Internet. However, the contents of the user's home directory web mounted in `/usr/home/web` inside the jail must be encrypted.

Since the server load, we will need to manually enter master password, do yourself sending message to email for those cases where the server can be restarted without our knowledge. For this `/etc/crontab` drop the line:

```
@reboot root /bin/echo "Incident date: `/bin/date`"| mail -s "`/bin/hostname` rebooted" your_mail@my.domain
```

, where *your_mail@my.domain* - is your E-mail.

Perform initialization of master-image **CBSD**, where will be stored all the keys to the images. You will be prompted to enter the passphrase for decrypting this image again to initialize it immediately. Do not forget it.

```
% cbsd geli mode=initmaster
Initialization. Please set master password for geli base image
Enter new passphrase:
Reenter new passphrase:
Attaching geli base image. Please use master password.
Enter passphrase:
Init complete: /usr/jails/var/db/master_geli.img
```

Initialize GELI on this file. A phrase that you enter for the decryption will be saved as a file within the encrypted master password image `/usr/jails/var/db/master_geli.img`, you created above.

```
% cbsd geli mode=init file=/usr/jails/jails-system/private1/home_web.img
Metadata backup can be found in /var/backups/md1.eli and
can be restored with the following command:

# geli restore /var/backups/md1.eli /dev/md1

/dev/md1.eli
```

The `/dev/md1.eli` file in output is currently initialized GELI-image, which now need to create a file system.
You can verify that the file corresponds exactly to the image md1 `/usr/jails/jails-system/private1/home_web.img`, looking at the output of the command:

```
% mdconfig -vl
md0     vnode    5120K  /usr/jails/var/db/master_geli.img
md1     vnode      10G  /usr/jails/jails-system/private1/home_web.img
```

Create a file system:

```
% newfs -U -n -m0 /dev/md1.eli
```

It now remains to add to fstab of jail inforation about GELI image and mount point. Open or create a file `/usr/jails/jails-fstab/fstab.private1.local` and add string:

```
home_web.img /usr/home/web geli rw 0 0
```
Create empty directory /usr/home/web inside the jails, which will be the mount point:

```
% mkdir -p /usr/jails/jails-data/private1-data/usr/home/web
```
Additionally, make sure that the private1 jail will not try to run automatically, as in this case, without the primary initialization of CBSD GELI, jail will start with a empty `/usr/home/web`:

```
% cbsd jset jname=private1 astart=0
% cbsd jls display=jname,astart
JNAME     ASTART
private1  0
```
After that run the jail and remains convinced that the directory is mounted:

```
% cbsd jstart private1
% mount | grep "/usr/home/web"
/dev/md1.eli on /usr/jails/jails/private1/usr/home/web (ufs, local, soft-updates)
```

After each reboot the OS, you need to go on a one-time server and initialize the master-GELI image through command:

```
% cbsd geli mode=initmaster
```
Then before the next boot, CBSD be able to use individual keys for decrypt images for starting and stopping the jails themselves.
