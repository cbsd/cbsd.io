# Jail limits control

## jrctl, jrctl-tui commands

```
% cbsd jrctl
% cbsd jrctl-tui
```
**Description**

**CBSD** supports many of FreeBSD's mechanisms for enforcing limits on a jail's resource usage.

## File quotas

Floating file quotas are only possible for jails residing on **ZFS**-file system. For systems stored on **UFS** a similar restrictions can be enforced using an md(4)-based vnode file/image and making use of **mdsize** for the jail).

## Renice prioritization

**CBSD** uses [renice(8)](http://www.freebsd.org/cgi/man.cgi?query=renice&sektion=8) to prioritize each jail's access to the CPU. This makes it possible to select different priorities on a per jail basis and give the most impoartant jails the highest share of CPU time. For example, you may want to have your distcc jail set to a low priority, give your web server medium and the jail hosting the databse the highest priority. The actual priorization is taken care of by nice which gets the value for each jail from jail rctl. The values set here correspond to the behavior of **nice**(1) — the lowest integer resulting in the highest priority.

Renice example:

1) Let's create an AMP jail and have it run a php script that performs some work (such as [bench.zip](files/bench.zip) taken from [php-benchmark-script](http://www.php-benchmark-script.com/)). We then clone the jail, calling the first **highprio1** and the second **lowprio1**. Using **cbsd jrctl-tui** we give the first the highest possible priority **-20**, and set the second jail to the lowest priority of **20**. In addition we limit the jail to one core through **cpuset** with **cbsd jconfig*** (single-core systems are hard to come by these days and smart schedulers do not allow for a clean experiment without taking this step ;-).

```
% cbsd jls display=jid,jname,ip4_addr,cpuset
16   highprio1   10.0.0.121/24  4
17   lowprio1    10.0.0.122/24  4
```
— jid 16 is the higher prioritised jail while jid 17 — is set to a lower priority. Both run on the fourth core.

make poll top state congestion **php-fpm** with JID output:

```
% export iter=1
% while [ 1 ]; do
    printf "Iter: $iter" ;
    iter=$((iter+1))
    top -jab | grep php
    sleep 1
done
```
We launch the script on both IPs at the same time:

```
% fetch -T 300 -o /dev/stdout http://10.0.0.121 & fetch -T 300 -o /dev/stdout http://10.0.0.122 &
	[1] 65985
	[2] 65986

	--------------------------------------
	|        PHP BENCHMARK SCRIPT        |
	--------------------------------------
	Start : 2014-01-06 16:28:59
	Server : @10.0.0.121
	PHP version : 5.4.23
	Platform : FreeBSD
	--------------------------------------
	test_math                 : 12.870 sec.
	test_stringmanipulation   : 15.896 sec.
	test_loops                : 8.968 sec.
	test_ifelse               : 7.864 sec.
	--------------------------------------
	Total time:               : 45.598 sec.

	--------------------------------------
	|        PHP BENCHMARK SCRIPT        |
	--------------------------------------
	Start : 2014-01-06 16:29:02
	Server : @10.0.0.122
	PHP version : 5.4.23
	Platform : FreeBSD
	--------------------------------------
	test_math                 : 32.632 sec.
	test_stringmanipulation   : 18.053 sec.
	test_loops                : 6.323 sec.
	test_ifelse               : 5.504 sec.
	--------------------------------------
	Total time:               : 62.512 sec.

	[2]    Done                          fetch -T 300 -o /dev/stdout http://10.0.0.122
	[1]  + Done                          fetch -T 300 -o /dev/stdout http://10.0.0.121

```
and we can soon observe the following output from top:

```
Iter: 1
	65101  16 www           1  35  -20 32548K 11456K CPU4    4   0:35  20.56% php-fpm: pool www (php-fpm)
	65587  17 www           1  52   20 32548K 11456K RUN     4   0:32   0.00% php-fpm: pool www (php-fpm)
	Iter: 2
	65101  16 www           1  60  -20 32548K 11456K RUN     4   0:36  25.98% php-fpm: pool www (php-fpm)
	65587  17 www           1  42   20 32548K 11456K CPU4    4   0:33   2.10% php-fpm: pool www (php-fpm)
	Iter: 3
	65101  16 www           1  60  -20 32548K 11456K CPU4    4   0:36  26.27% php-fpm: pool www (php-fpm)
	65587  17 www           1  94   20 32548K 11456K RUN     4   0:33   8.59% php-fpm: pool www (php-fpm)
	Iter: 4
	65101  16 www           1  61  -20 32548K 11456K CPU4    4   0:37  31.69% php-fpm: pool www (php-fpm)
	65587  17 www           1  95   20 32548K 11456K RUN     4   0:34   9.47% php-fpm: pool www (php-fpm)
	Iter: 5
	65101  16 www           1  62  -20 32548K 11456K CPU4    4   0:37  35.60% php-fpm: pool www (php-fpm)
	65587  17 www           1  95   20 32548K 11456K RUN     4   0:34  11.18% php-fpm: pool www (php-fpm)
	Iter: 6
	65101  16 www           1  64  -20 32548K 11456K CPU4    4   0:38  38.96% php-fpm: pool www (php-fpm)
	65587  17 www           1  96   20 32548K 11456K RUN     4   0:34  12.79% php-fpm: pool www (php-fpm)
	...
```

The jail with jid 16 is getting a larger share of the available CPU cycles and executes almost 1.5 times faster.

## RACCT/RCTL framework

If your kernel has support RACCT/RCTL, you can set limits on the jail and watch the current statistics for jail resources. To do this, there is a command cbsd jrctl, which arguments

```
% cbsd jrctl mode=apply  ...
```
and

```
% cbsd jrctl mode=unset  ...
```
automatically called for the install or removal of limits when working **jstart** or **jstop** respectively. By command:

```
% cbsd jrctl mode=show
```
you can see current statistics on the jail resources consumed, which can be used to generate reports and graphs for loading jail, as well as the **CBSD** daemon used to generate recommendations on the need to add new resources and for overload warnings.

By command:

```
% cbsd jrctl
```
or, if you build a hosting and want to create limits on non-interactively, you can generate a file `$workdir/$jname/jail.limits`

By jrctl you can set the following limits jail:

a) All you can do a framework FreeBSD [rctl(8)](http://man.freebsd.org/rctl/8):

|cputime 	|   CPU time, in seconds|
| ---     |     ---               |
| datasize	|   data size, in bytes |
|	stacksize	|   stack size, in bytes |
| coredumpsize |  core dump size, in bytes |
|	memoryuse	|   resident set size, in bytes |
|	memorylocked	|  locked memory, in bytes |
| maxproc |	   number of processes |
|	openfiles	 |  file descriptor table size |
|	vmemoryuse	|  address space limit, in bytes |
|	pseudoterminals |  number of PTYs |
| swapuse 	|   swap usage, in bytes |
|	nthr |		   number of threads |
|	msgqqueued	|  number of queued SysV messages |
|	msgqsize	|  SysV message queue size, in bytes |
| nmsgq		|  number of SysV message queues |
|	nsem		|   number of SysV semaphores |
| nsemop	|	   number of SysV semaphores modified in a single semop(2) call |
|	nshm		|   number of SysV shared memory segments |
|	shmsize 	|   SysV shared memory size, in bytes |
|	wallclock	|   wallclock time, in seconds |

![](img/jrctl1.png)

![](img/jrctl2.png)

