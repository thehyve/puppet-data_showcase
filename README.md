# Puppet module for the Data showcase.

This is the repository containing a puppet module for deploying the _Data showcase_ application,
which can be found at <https://github.com/thehyve/data-showcase>.

The module creates system user `datashowcase`, and
installs and configures the service `data-showcase`.
The repository used to fetch the required packages is `repo.thehyve.nl`.

## Dependencies and installation

### Operating system packages
The module expects certain packages to be available through the package manager of the operating system (e.g., `yum` or `apt`):
- For all components:
  - `java-1.8.0-openjdk`

### Puppet modules
The module depends on the `archive` and `java` puppet modules.

The most convenient way is to run `puppet module install` as `root`:
```bash
sudo puppet module install puppet-archive
sudo puppet module install puppetlabs-java
```

If you want to let the module install PostgreSQL as well, install the `postgresql` module:
```bash
sudo puppet module install puppetlabs-postgresql
```

### Install the `data_showcase` module
Copy the `data_showcase` module repository to the `/etc/puppet/modules` directory:
```bash
cd /etc/puppet/modules
git clone https://github.com/thehyve/puppet-data_showcase.git data_showcase
```

## Configuration

### The node manifest

For each node where you want to install the data showcase, the module needs to be included with
`include ::data_showcase::complete`.

Here is an example manifest file `manifests/test.example.com.pp`:
```puppet
node 'test.example.com' {
    include ::data_showcase::complete
}
```
The node manifest can also be in another file, e.g., `site.pp`.

### Configuring a node using Hiera

It is preferred to configure the module parameters using Hiera.

To activate the use of Hiera, configure `/etc/puppet/hiera.yaml`. Example:
```yaml
---
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppet/hieradata'
:hierarchy:
  - '%{::clientcert}'
  - 'default'
```
Defaults can then be configured in `/etc/puppet/hieradata/default.yaml`, e.g.:
```yaml
---
data_showcase::environment: Public
```

Machine specific configuration should be in `/etc/puppet/hieradata/${hostname}.yaml`, e.g.,
`/etc/puppet/hieradata/test.example.com.yaml`:
```yaml
---
data_showcase::db_user: test
data_showcase::db_password: my secret
data_showcase::db_host: 10.0.2.2
data_showcase::db_name: transmart
data_showcase::db_port: 1521
data_showcase::memory: 4g
data_showcase::environment: Public
data_showcase::version: 0.0.1-SNAPSHOT
```

### Configuring a node in the manifest file

Alternatively, the node specific configuration can also be done with class parameters in the node manifest.
Here is an example:
```puppet
node 'test.example.com' {
    # Site specific configuration for the data showcase
    class { '::data_showcase::params':
        db_user      => 'test',
        db_password  => 'my secret',
        db_port => 1521,
        db_name => 'transmart,
    }

    include ::data_showcase::complete
}
```


## Masterless installation
It is also possible to use the module without a Puppet master by applying a manifest directly using `puppet apply`.

There is an example manifest in `examples/complete.pp` for generating the required configuration files and installing
`data-showcase`.

```bash
sudo puppet apply --modulepath=${modulepath} examples/complete.pp
```
where `modulepath` is a list of directories where Puppet can find modules in, separated by the system path-separator character (on Ubuntu/CentOS it is `:`).
Example:
```bash
sudo puppet apply --modulepath=${HOME}/puppet/:/etc/puppet/modules examples/complete.pp
```

## Database installation and preparation

### Create a PostgreSQL database
To install `postgresql` with the database admin credentials, run:
```bash
sudo puppet apply --modulepath=${modulepath} examples/postgres.pp
```

### Prepare the database for the data showcase
Source the `vars` file (as user `tsloader`):
```bash
sudo -iu postgres psql
```
Create the database and load essential data:
```sql
create
```

## Manage `systemd` services 

Start the `data-showcase` service:
```bash
sudo systemctl start data-showcase
```
Check the status of the service:
```bash
sudo systemctl status data-showcase
```
Stop the service:
```bash
sudo systemctl stop data-showcase
```
Check a full log of service build
```bash
journalctl -u data-showcase - build log
```


## Test
The module has been tested on Ubuntu 16.04 with Puppet version 4.
There are some automated tests, run using [rake](https://github.com/ruby/rake).

A version of `ruby` before `2.3` is required. [rvm](https://rvm.io/) can be used to install a specific version of `ruby`.
Use `rvm install 2.1` to use `ruby` version `2.1`.

### Rake tests
Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
bundle
```
or using `rvm`:
```bash
rvm install 2.1
gem install bundler
bundle
```
Run the test suite:
```bash
rake test
```

## Classes

Overview of the classes defined in this module.

| Class name | Description |
|------------|-------------|
| `::data_showcase` | Creates the system users. |
| `::data_showcase::config` | Generates the application configuration. |
| `::data_showcase::service` | Installs the `data-showcase` service. |
| `::data_showcase::complete` | Installs all of the above. |
| `::data_showcase::database` | Installs `postgresql` with the database admin credentials. |


## Module parameters

Overview of the parameters that can be used in Hiera to configure the module.
Alternatively, the parameters of the `::transmart_core::params` class can be used to configure these settings.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `data_showcase::version` | `0.0.1-SNAPSHOT` | The version of the data showcase to install. |
| `data_showcase::nexus_url` | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `data_showcase::repository` | `releases` | The repository to use. [`snapshots`, `releases`] |
| `data_showcase::user` | `datashowcase` | System user that runs the application. |
| `data_showcase::user_home` | `/home/${user}` | The user home directory |
| `data_showcase::db_user` | | The database admin username. (Mandatory) |
| `data_showcase::db_password` | | The database admin password. (Mandatory) |
| `data_showcase::db_host` | `localhost` | The database server host name. |
| `data_showcase::db_port` | `5432` | The database server port. |
| `data_showcase::db_name` | `data-showcase` | The database name. |
| `data_showcase::memory` | `2g` | The memory limit for the JVM. |
| `data_showcase::app_port` | `8080` | The port the `data-showcase` application runs on. |
| `data_showcase::environment` | `Public` | The environment to configure the system for [`Public`, `Internal`]. |


## License

Copyright &copy; 2017  The Hyve.

The puppet module for TranSMART is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](LICENSE) along with this program. If not, see https://www.gnu.org/licenses/.
