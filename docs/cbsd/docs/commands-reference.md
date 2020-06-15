| Command | Description |
| - | - |
| initenv | Node re-initialization |

## bhyve
| Command | Description |
| - | - |
| bcheckpoint           |bhyve checkpoint|
| bclone                |bhyve cloning|
| bconfig               |Configure for bhyve|
| bconstruct-tui        |Ncurses based bhyve guest creation wizard|
| bcontrol-tui          |Ncurses based control for bhyve|
| bcreate               |Create bhyve from config file|
| bexport               |Export bhyve into image|
| bget                  |Get info related to bhyve domain|
| bhyve-controller      |Manage bhyve controller|
| bhyve-controller-tui  |TUI for bhyve storage controller|
| bhyve-dsk             |Manage bhyve ahci/virtio disk|
| bhyve-dsk-list        |Show disk images from database|
| bhyve-nvme            |Manage bhyve NVMe storage controller|
| bhyve-nvme-tui        |TUI for bhyve NVMe storage controller|
| bhyve-p9shares        |Manage bhyve p9 shared folders|
| bhyve-ppt             |Manage bhyve ppt devices|
| bimport               |Import bhyve from image|
| blogin                |Exec login into jail|
| bls                   |List bhyve domain and status|
| border                |List bhyve run order|
| border-tui            |Ncurses based bhyve order editor|
| bpause                |Pause and resume for bhyve domain (send STOP/CONT signal to bhyve vm process)|
| bremove               |Destroy bhyve domain|
| brename               |Rename bhyve|
| brestart              |bhyve bstop bstart sequence|
| bset                  |Modify parameter for bhyve|
| bsetup-tui            |Ncurses based setup for bhyve-arg|
| bstart                |Start bhyve domain|
| bstop                 |Stop bhyve domain|
| buildkernel           |Build kernel from sources|
| buildworld            |Buildworld from sources|
| distribution          |make distribtion for FreeBSD base|
| installkernel         |Build kernel from sources|
| installworld          |Installbase from obj|
| kernel                |Build kernel from sources|
| objls                 |List of object file|
| removebase            |Remove base dir|
| removekernel          |Remove base dir|
| vhidcfg-tui           |Edit properties for vitual image of VM|
| world                 |Buildworld from sources|

##jail
| Command | Description |
| - | - |
| expose                |Exposing a port to jail from master host|
| j2prepare             |Prepare remote node for accepting jail via j2slave|
| j2slave               |Transfer jail as slave jail to remote node|
| jcleanup              |Force unmount and cleanup for offline jail|
| jclone                |Jail cloning|
| jcoldmigrate          |Cold migrate (with save status) jail to remote node, set local jail as slave|
| jconfig               |Configure for jail|
| jcontrol-tui          |Ncurses based control for jail|
| jcreate               |Create jail from config file. If jail exist and autorestart=1 - jset will be used to update params.|
| jdescr                |Show or modify jail description|
| jexec                 |Execution for command inside jail|
| jexport               |Export jail into image|
| jget                  |Get info related to jail|
| jimport               |Import jail from image|
| jlogin                |Exec login into jail|
| jls                   |List and show status of jails|
| jmkrcconf             |Create ascii rc.conf for jail|
| jmkrctlconf           |Import or export from/to ascii rctl.conf from/to SQLite3 tables for jail|
| jorder                |List jail run order|
| jpause                |Pause and resume for jail (send STOP/CONT signal to jail processes)|
| jrclone               |Clone jail to remote machine|
| jrctl                 |Set or flush resource limit for jail|
| jrctl-tui             |Dialog based UI for RACCR/RCTL|
| jregister             |Register jail records to SQLite from ASCii config or re-populate ASCii config from SQLite|
| jremove               |Destroy jail|
| jrename               |Rename jail|
| jrestart              |jail jstop jstart sequence|
| jset                  |Modify parameter for jail|
| jsetup-tui            |Ncurses based setup for jail-arg|
| jsnapshot             |Jail snapshot management|
| jstart                |Start jail|
| jstatus               |Return jail ID in output and jail existance as error code (0: no jail, 1: jail exist)|
| jstop                 |Stop jail|
| jswmode               |Jail switch mode between master/slave|
| junregister           |Register jail records to SQLite from ASCii config or re-populate ASCii config from SQLite|
| jupgrade              |Upgrade jail base data when baserw=1|
| jwhereis              |Return node for jname|
| sockstat              |return list open sockets for jail|

## node
| Command | Description |
| - | - |
| ndescr                |Show or modify node description|
| nlogin                |Login to remote node and/or exec command|
| node                  |Manipulate or show information for remote nodes|

## sys
| Command | Description |
| - | - |
| bases                 |Show BSD bases|
| baseupdate            |Update base jail|
| carpcfg               |Enable CARP configuration|
| delete-old-libs       |make delete-old and delete-old-libs for base|
| forms                 |Ncurses-based jail image boostrap helper|
| geli                  |cbsd geli helper|
| getnics-by-ip         |Return network interface name by ip|
| help                  |This help|
| history               |Show cbsd history command|
| initenv-tui           |Node re-initialization|
| jail2iso              |Convert jail into cd9660 ISO or memstick image|
| jailmapdb             |Return or update node for jail map in ASCII file|
| jbackup               |Backup jail to slave node with slave status|
| jconstruct            |console dialog for jail creation|
| jconstruct-tui        |Ncurses based jail creation wizard|
| jorder-tui            |Ncurses based jail order editor|
| kernels               |Show BSD kernels|
| makejconf             |Make jailv2 config file|
| makescene             |Make jail by scenario file|
| media                 |Operate with virtual storage media such as ISO|
| mountfstab            |Mount jail by fstab file|
| natcfg                |Enable NAT service for RFC1918 Networks|
| natcfg-tui            |Configuring NAT in text-user dialog|
| natoff                |Disable NAT service for RFC1918 Networks|
| naton                 |Enable NAT service for RFC1918 Networks|
| netinv                |Update Network-related information in inventory tables|
| portsup               |Update FreeBSD ports tree in /usr/ports|
| removeobj             |Remove obj-dir|
| removesrc             |Remove src-dir|
| repo                  |Working with CBSD Repository|
| retrinv               |Fetch sqldb from remote node|
| rexe                  |Execute remote command using ssh on the node|
| rsyncdoff             |Disable RSYNC service for jail migration|
| rsyncdon              |Enable RSYNC service for jail migration|
| show_profile_list     |Operate with bhyve disk images and database|
| sources               |Show BSD sources|
| srcpatch              |Apply CBSD patch for FreeBSD source tree in /usr/jails/src|
| srcup                 |Update FreeBSD source tree in /usr/jails/src|
| sshkey                |Manage node ssh key: replace or update new pair in CBSD .ssh directory|
| summary               |Show summary statistics for the farm|
| sysinv                |Collect and/or update system-related information in inventory tables|
| trafstat              |Show traffic statistics for the virtual environment|
| unmountfstab          |Unmount jail by fstab file|
| upgrade               |Upgrade base and/or kernel from other prepared hier|
| xconstruct-tui        |Ncurses based Xen guest creation wizard|

## xen
| Command | Description |
| - | - |
| xcheckpoint           |xen checkpoint|
| xconfig               |Configure XEN domain|
| xcreate               |Create jail from config file|
| xget                  |Get info related to xen domain|
| xls                   |List XEN domain and status|
| xremove               |Destroy XEN domain|
| xset                  |Modify parameter for jail|
| xsetup-tui            |Ncurses based setup for jail-arg|
| xstart                |Start XEN domain|
| xstop                 |Stop jail|
