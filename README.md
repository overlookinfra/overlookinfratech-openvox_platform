# Reference architecture for the OpenVox platform.

This is our [WIP] opinionated reference architecture for the OpenVox platform.
This implements the following node types:

1. [The *primary* OpenVox server](#primary-openvox-server):
    - OpenVox agent
    - OpenVox server
    - OpenVoxDB
    - Foreman web UI
        - Redis Rails cache
        - the preferred option of non-EOL vendor provided PostgreSQL
    - Regular PostgreSQL backups, including both Foreman and OpenvoxDB tables
    - Full two-way integration between OpenVox and Foreman
    - [todo] Performance tuning profiles
2. [\[todo\] The *secondary* OpenVox compiler nodes](#secondary-openvox-compilers):
    - OpenVox agent
    - OpenVox server
    - Codebase deployment configured
    - Central reporting
    - Performance tuning profiles
3. [\[todo\] OpenVox agent nodes](#openvox-agents):
    - OpenVox agent
    - Optional serverless configuration
        - Codebase deployment configured
        - Central reporting

> ⚠️ **This module is still under heavy development** and the interface is expected
> to change drastically. Do not take configuration choices we've made with this module
> as recommendations (yet). See [#limitations](#limitations) and don't use the module yet.
> Contributions and suggestions are very happily accepted.


## Node Ownership

The `server` and `compiler` profiles are intended to have full ownership of a node.
You may add on things like Foreman smart proxies or plugins such as the
[Hiera Data Manager](https://github.com/betadots/hdm/), but don't also try to run
your company website or anything on it.


## Usage

### Primary OpenVox Server

This is the most common use of this module. Simply include it on a node to
configure a primary server with OpenVoxDB and a standard Foreman configuration.

```puppet
include openvox_platform
```

You may also choose to disable Foreman or OpenVoxDB to get these standard stacks:

| Foreman | OpenVoxDB | standard configuration          |
|:-------:|:---------:|---------------------------------|
|   ✅    |    ✅     | primary OpenVox server          |
|   ⛔️    |    ✅     | no GUI primary OpenVox server   |
|   ⛔️    |    ⛔️     | secondary OpenVox compiler node |
|   ✅    |    ⛔️     | no OpenVoxDB (not recommended)  |

There are several optional configuration parameters you may set. Please see the
class documentation for more information.

#### Advanced usage

If you would like to customize the Foreman, OpenVoxDB, or PostgreSQL beyond the
options provided, you may use the standard Hiera parameters for the underlying
component modules. If you have a [support plan](https://voxpupuli.org/openvox/support/)
then check with your provider for support options.

### Secondary OpenVox Compilers

**[todo]** To configure a node as a secondary compiler, just classify it without
enabling Foreman or OpenVoxDB. It will configure itself with a copy of the Puppet
codebase and to send reports back to the primary server.

```puppet
class { 'openvox_platform':
  foreman  => false,
  puppetdb => false,
}
```

### OpenVox Agents

**[todo]** Use the `openvox_platform::agent` class to configure agents. You should
include this on all nodes in your infrastructure. If you intend to run serverless
then specify a `control_repository` and optionally an update frequency.



## Limitations

This module ***is not ready for production use*** yet. You are welcome to kick the
tires and poke & prod all you like, but please don't rely on it yet. It will be
heavily refactored as we flesh out how the platform will work. Parameters will
change and the way data & parameters are passed will change. Class names will be
refactored and may or may not have a 1-1 translation. This is currently only
regularly tested on x86 CentOS 9 until we set up proper pipeline testing.
