#Work with CBSD through Puppet

When you operate a large number of nodes and containers, handmade container management becomes ineffective

There are many of today's popular configuration management systems: Ansible, Chef, Saltstack, Puppet etc., written in different languages and with different concepts and principles of.

At this point, we support a [CBSD module for Puppet](https://forge.puppet.com/olevole/cbsd)


## How to use puppet with the CBSD puppet module

Puppet CBSD module allows to write server configuration using declarative programming (Ruby DSL, domain-specific language).

In other words, you create a manifesto describing what the container and with what parameters and characteristics should be on a particular server.

Further work on the implementation of these requirements **Puppet** takes over.
Examples of the use of the module

For installing **CBSD** on the server, just declare the class cbsd:

```
class { 'cbsd': }
```
If you are installing **CBSD** manually (eg not via pkg/ports, and have Git version, you can disable installation/registration CBSD package by module:

```
class { 'cbsd':
    manage_repo => false,
}
```
In the class of all parameters can be defined initenv. For example, to initialize **CBSD** with /usr/jails workdir and enable **NAT** framework:

```
class { 'cbsd':
    jnameserver => "8.8.8.8",
    nat_enable => '1',
    defaults => {
        'workdir'         => '/usr/jails',
    }
}
```

You can force CBSD download specific base version:

```
class { "cbsd::freebsd_bases":
    ver => [ '12' ],
    stable => 1,
}
```
Create jail:

```
cbsd::jail { 'myjail0':
    pkg_bootstrap => '0',
    host_hostname => 'myjail0.my.domain',
}
```

If you prefer to work with parameters through Yaml, в Hierra it might look like:

```
cbsd::jails:
  myjail0:
    host_hostname: 'myjail0.my.domain'
```
