# History of CBSD commands

***history command***

```
% cbsd history
```

**Descriptions:**

When **CBSD** is run from the terminal and the environment variable **NO_CBSD_HISTORY** isn't set, the command will be logged to `$workdir/.cbsd_history`.

You can use the command

```
% cbsd history [N]
```

(with N as optional parameter) to display all entered **CBSD** commands or only the last N entries. The size of `$workdir/.cbsd_history` is limited in 300 Kb by default. Once the size limit is reached space for newer entries is created by dropping the oldest entries as needed.
