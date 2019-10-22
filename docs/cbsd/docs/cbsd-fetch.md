#CBSD Fetch

## Description

With **CBSD**, you may need to download any additional resources from the Internet. It can be, for example: FreeBSD base for building a jail, the ISO image of the OS you want to install, the various templates and service images of virtual machines.

It's important to understand that the links to these resources are stored in certain configuration files, monitored and verified by the **CBSD** project participants.

To ensure integrity and security, configuration files contain a checksum of **sha256** that corresponds to the received file of your **CBSD**.

The CRC amounts are also accompanied by the **CBSD** project participants and are taken from official sources (OS website, official FreeBSD website, etc.).

As the information on the Internet is in constant dynamic motion, some resources have properties that become obsolete or disappear through the old links, and this happens very often.

The **CBSD** project in most cases tries to protect users from such changes - for this we have launched the official mirror for **CBSD resources**, and we very much welcome any help with resources and maintenance project on the part of users. You can read about this in the "*Expand Resource Mirror* **CBSD**" section below.

## fetch.conf

Configuration files for **CBSD** that contain links to external resources (for example, bhyve virtual machine templates located in the `$workdir/etc/defaults/` directory and starting with **vm**-*, are divided into two types:

* **iso_site** - the official site or official mirror of the project, the main data source. It is from these resources that the sum of the CRC files is counted.
* **cbsd_iso_mirrors** is the official mirror for the CBSD project. These mirrors participate in receiving files, but they are never used as a source of CRC sums, since they can be located to the resources of the user or partner. Ensuring the integrity of these mirrors is guaranteed by checking the amount of SHA256 created by the source file.

If there are several mirrors, **CBSD** automatically scans them within a few seconds that are most useful to you. This happens by measuring the download speed from each resource of a small part data. It does not matter in which order the mirrors are written in the configuration file - **CBSD** reorganizes the order of the mirrors with the maximum benefit for your connection.

There are times when the file specified in the configuration file changes on the official resource, and for this reason it does not pass the verification. In this case, two behavioral algorithms the **broken_crc_fetch_order** parameter in the configuration file **fetch.conf**:

* **cbsd_mirror** - in case the amount of CRC on the first attempt was incorrect, build the following list of mirrors in such a way that the second attempt necessarily took place with the official mirror CBSD, and only then - all the rest.
* **mirror_list** - the download will go strictly by sorting, unchanged.

In both cases, attempts to download a file will continue until the file is found with the correct amount of CRC or the list of mirrors ends.

By default, the **broken_crc_fetch_order="mirror_list"** method is selected, if you prefer to change the behavior to the first option, overwrite this parameter, creating a file in `$workdir/etc/fetch.conf` and reassigning the parameter:

```
broken_crc_fetch_order="cbsd_mirror"
```
This option may save traffic if the CBSD speed rating is at the bottom of the list.

If you notice an incorrect amount of CRC, you can help the project and send a profile update and the amount of CRC, as described below.

## If the CRC does not match

During the release of **CBSD**, all profiles are checked and contain the correct amounts of CRC, however this situation may change over time - for example, OS authors released an update to the image on their resource.

In such cases, the attempt to get an image from the official site (and its mirrors) will result in a CRC amount error, while the official CBSD mirrors of the project will return the correct, but old copy.

In such cases, you need to update the checksums in the profiles and update the image.

 The first thing you can do if you are in this situation - try to update your profiles with [GitHub](https://github.com/cbsd/cbsd-vmprofiles)- then, in your situation already updated these profiles for you.

 To do this, your system must have the **git** utility installed. The update occurs through the Makefile script in the `$workdir/etc`. To update:

  You can add this operation to crontab for automatic periodic updates. If you do this for the first time, before you update the profile, you must initialize the git repository (it is executed only once):

  ```
  make -C ~cbsd/etc profiles-create
  ```
 If there are no updates, you can help the project (and make the same users happy as you are) by creating a **GitHub** corresponding **pull-request** to change the CRC (or updating links and versions).

  If you are at your own risk and want to take an ISO image, despite the discrepancy between the amounts of CRC, you have two options:

*  Adjust the **sha256sum** value in a particular profile by setting **sha256sum=0**. When **sha256sum=0**, this causes  to skip the CRC check. Refer to the section [**CBSD** profiles](../tutorials/profiles-for-jail-creation.md) for details on how to overwrite certain parameters.

* Prevent CRC checksums globally through the **BSD_ISO_SKIP_CHECKSUM=[yes|no]** environment variable (or configuration file), for example:` env CBSD_ISO_SKIP_CHECKSUM=yes cbsd bstart`

To automatically update CRC amounts in profiles, you can use the fetch_iso script, which we will discuss below.

## Affiliate program or "Expand the CBSD Resource Mirror"

 To simplify tasks for working with CRC amounts, the script **fetch_iso** is written. The scenario solves two main tasks:

* Automatically update sha256 amounts in profiles by uploading ISO image (only from official resources, **iso_site**) and recalculating sha256, then CRC is updated in the file `/usr/local/cbsd/etc/defaults/vm-*`. For this to take effect, you must **cbsd initenv**. In addition, this file can be sent pull-request through **GitHub**. To do this, use the **fetch_iso** call with the **gensha256=1** argument.

*  Help **CBSD** users to automate the process of creating their own mirrored resources referenced by profiles.

 In turn, the process of creating your own mirror can be divided into two types:

 * with the **keepname=1** argument - save the ISO under this name, since they are listed in the source (official) resource. This option can be used if you want to raise your own local mirror **CBSD** and use it as a local resource (and, of course, the fastest resource available to you).

* with the **keepname=0** argument - in this case, the files will be saved under the names that are waiting for CBSD profiles. This operation can be performed as a "warm-up" of images, with the goal of downloading all the resources for yourself in advance. Typically, **dstdir=** is the `/usr/jails/src/iso` directory (if `$workdir=/usr/jails`), in which CBSD stores all ISO images.

If you have the processing power available on the Internet (hosting, data center, etc.), you can create your own **CBSD mirror** and publish a link to your profiles in it virtual machines. So, you become a participant in the **CBSD** project and help your region (country) get, perhaps, the best mirror for them.

n addition, for those who want to help the project with a local mirror in your resources, in the RO mode, an rsync server is open, from which you can initiate through cron content synchronization. The URL of this property is `rsync://electro.bsdstore.ru/iso/`. If your mirror is accessible from the Internet, you can send pull-request to **GitHub** to the repository [https://github.com/cbsd/cbsd-vmprofiles](https://github.com/cbsd/cbsd-vmprofiles) by adding your mirror to **cbsd_iso_mirrors=**. With the release of the new version of **CBSD** your mirror will go to **CBSD**.

## How to setup a mirror, HowTo

Step-by-step setup of the mirror with periodic synchronization via [rsync](http://rsync.samba.org/) in [crontab(5)](http://man.freebsd.org/crontab/5):

1) Install packages:

```
pkg install -y rsync nginx
```
2) Activate nginx services:

```
sysrc nginx_enable="YES"
```

3) Create `/usr/local/www/cbsd-mirror` directory where we will save ISO images, create a log file for rsync and set the right permissions for the **www** user, from which we will synchronize

```
mkdir -p /usr/local/www/cbsd-mirror/iso
touch /var/log/cbsd_mirror.log
chown -R www:www /usr/local/www/cbsd-mirror /var/log/cbsd_mirror.log
```

4) Correct **nginx.confi**, specifying **server_name** as correct name of the server (in this example: **electrode.bsdstore.ru**) and set path to root directory:


```
cat > /usr/local/etc/nginx/nginx.conf <<EOF
		user nobody;
		worker_processes  2;

		error_log /var/null;
		pid /var/run/nginx.pid;

		events {
			worker_connections  1024;
			kqueue_changes  1024;
			use kqueue;
		}

		http {
			server_tokens off;
			include       mime.types;
			default_type  application/octet-stream;

			log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
				'$status $body_bytes_sent "$http_referer" '
				'"$http_user_agent" "$http_x_forwarded_for"';

			error_log       /dev/null;
			access_log      /dev/null;
			client_header_timeout  3m;
			client_body_timeout    3m;
			send_timeout           3m;
			client_header_buffer_size    1k;
			large_client_header_buffers  4 8k;
			client_body_buffer_size 32K;
			log_not_found off;

			client_max_body_size 20m;

			gzip off;
			output_buffers   1 32k;
			postpone_output  1460;
			reset_timedout_connection  on;
			sendfile         on;
			tcp_nopush       on;
			tcp_nodelay      on;
			send_lowat       12000;
			keepalive_timeout  8;

			server {
				listen       *:80;
				#listen      [::]:80;	# Enable IPv6

				server_name  electrode.bsdstore.ru;
				access_log /var/log/nginx/electrode.bsdstore.ru.acc main;
				error_log /var/log/nginx/electrode.bsdstore.ru.err;

				root   /usr/local/www/cbsd-mirror;
			}
		}
		EOF

```

5) Create an entry in crontab with the rsync call for 15 minutes through lockf to stop duplication of processes

```
cat > /etc/cron.d/cbsd_mirror <<EOF
SHELL=/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
*/15    *       *       *       *       www /usr/bin/lockf -s -t0 /tmp/cbsd_mirror.lock /usr/local/bin/rsync -a --delete rsync://electro.bsdstore.ru/iso/ /usr/local/www/cbsd-mirror/iso/ > /var/log/cbsd_mirror.log 2>&1
EOF
```

6) Start WEB service

```
service nginx restart
```

After synchronizing the directory and verifying that the ISO images from your resource are available to the rest of the world - you can send [Pull Request](https://github.com/cbsd/cbsd-vmprofiles/pulls) in [profiles project](https://github.com/cbsd/cbsd-vmprofiles) with added your servers in **cbsd_iso_mirrors** params of VM config files.
