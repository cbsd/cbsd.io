# Reggae Quick Start Guide

## Initialization

Install Reggae from ports or pkg:

```
make -C /usr/ports/sysutils/reggae install
```

```
pkg install -y reggae
```

Initialize PF, CBSD and ZFS dataset:

```
reggae network-init # it sets up PF, Unbound and SSH, which you should (re)start
reggae cbsd-init
reggae master-init # creates resolver and dhcp jails
```

In most cases, the default config is acceptable, but if you want to change something /usr/local/etc/reggae.conf is the right place

## Create service

Create simple service

```
mkdir myservice
cd myservice
reggae init
make
```

Create service with shell and ansible provisioners

```
mkdir myservice
cd myservice
reggae init shell ansible
make
```

## Create project

Project consists of multiple services

```
mkdir myproject
cd myproject
reggae project-init
```

Resulting Makefile is this:

```
REGGAE_PATH = /usr/local/share/reggae
#SERVICES = consul https://github.com/mekanix/jail-consul \
#      letsencrypt https://github.com/mekanix/jail-letsencrypt \
#      ldap https://github.com/mekanix/jail-ldap \
#      mail https://github.com/mekanix/jail-mail \
#      jabber https://github.com/mekanix/jail-jabber \
#      webmail https://github.com/mekanix/jail-webmail \
#      web https://github.com/mekanix/jail-web \
#      webconsul https://github.com/mekanix/jail-webconsul

.include <${REGGAE_PATH}/mk/project.mk>
```

Every service that is commented out is created using reggae init and edited to add extra functionality.
