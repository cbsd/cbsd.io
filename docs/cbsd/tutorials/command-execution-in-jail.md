# Command execution in jail

**command: jexec**

```
% cbsd jexec
```

Description:

You can run the command in the container from the master environment via **jexec** command

The required parameter is the name of the jail via **jname=**. Everything that comes after - is directly a command and arguments that will be launched in the jail

You can run a command in one container or simultaneously in several. To do this, use the jname= argument mask of the jails name in which the command will be executed.

For example, a mask of the form jname='test*jail' will execute the command in containers with the same name as test1jail, test2jail and so on. If you want to run the command at once in all containers of this node, use jname='*'

Be careful when launching long commands or actions that can lead to interactive dialogues. You can get the output of the last entries of the active log files through the sending of the SIGINFO command by pressing the Ctrl + 't' keys - this functionality will allow you to see and understand at what stage the command is executed in a container.

You will see the execution result on stdout, while the auxiliary messages are on stderr, respectively, if CBSD messages prevent you, use redirection stderr to /dev/null

**Example:**

```
% cbsd jexec jname='jail*' pkg update -f
% cbsd jexec jname='*' pkg update -y
% cbsd jexec jname='*' pkg clean -ya
```

![](img/jexec1.png)

Multiple command execution:


<script type="text/javascript" src="https://asciinema.org/a/136221.js" id="asciicast-136221" async></script>
