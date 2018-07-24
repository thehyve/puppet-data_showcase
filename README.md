# Puppet module for the Data showcase.

[![Build Status](https://travis-ci.org/thehyve/puppet-data_showcase.svg?branch=master)](https://travis-ci.org/thehyve/puppet-data_showcase/branches)

This is the repository containing a puppet module for deploying the _Data showcase_ application,
which can be found at <https://github.com/thehyve/data-showcase>.

The module creates system user `datashowcase`, and
installs and configures the service `data-showcase`.
The repository used to fetch the required packages is `repo.thehyve.nl`.


## Dependencies and installation

### Install Puppet
```bash
# Install Puppet
apt install puppet

# Check Puppet version, Puppet 4.8 and Puppet 5 should be fine.
puppet --version
```

### Puppet modules
The module depends on the `archive` and `java` puppet modules.
If you want to let the module install PostgreSQL as well, install the `postgresql` module:


The most convenient way is to run `puppet module install` as `root`:
```bash
sudo puppet module install puppet-archive
sudo puppet module install puppetlabs-java -v 2.4.0
sudo puppet module install puppetlabs-postgresql
```

Check the installed modules:
```bash
sudo puppet module list --tree
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
  :datadir: '/etc/puppet/code/hiera'
:hierarchy:
  - '%{::clientcert}'
  - common
```
Defaults can then be configured in `/etc/puppet/code/hiera/common.yaml`, e.g.:
```yaml
---
data_showcase::environment: Public
```

Machine specific configuration should be in `/etc/puppet/code/hiera/${hostname}.yaml`, e.g.,
`/etc/puppet/code/hiera/test.example.com.yaml`:
```yaml
---
data_showcase::db_user: datashowcase
data_showcase::memory: 4g
data_showcase::environment: Public
data_showcase::version: 1.0.3
data_showcase::access_token: configure a secret token
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
        access_token => 'configure a secret token',
    }

    include ::data_showcase::complete
}
```


## Masterless installation
It is also possible to use the module without a Puppet master by applying a manifest directly using `puppet apply`.
The configuration then still needs to be present in the Hiera files.

There is an example manifest in `examples/complete.pp` for generating the required configuration files and installing
`data-showcase`.

```bash
cd /etc/puppet/code/modules/data_showcase
sudo puppet apply examples/complete.pp
```


## Load data

```bash
file=data-showcase.json
token=configure a secret token
data_showcase_url=http://localhost:8080

# Upload data
curl -v -F "data=@${file}" "${data_showcase_url}/api/data_import/upload?requestToken=${token}"
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


## Development

### Prepare the database for the data showcase

```bash
sudo -iu postgres psql
```
Create the database:
```sql
create user datashowcase with password 'my secret';
create database data_showcase;
grant all privileges on database data_showcase to datashowcase;
```


### Test
The module has been tested with Puppet 5 on Ubuntu 16.04 and with Puppet 4.8.2 on Debian 9.
There are some automated tests, run using [rake](https://github.com/ruby/rake).

`ruby 2.3` is required. [rvm](https://rvm.io/) can be used to install a specific version of `ruby`.
Use `rvm install 2.3` to use `ruby` version `2.3`.

#### Rake tests
Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
or using `rvm`:
```bash
rvm install 2.3
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
Run the test suite:
```bash
rake test
```

### Classes

Overview of the classes defined in this module.

| Class name | Description |
|------------|-------------|
| `::data_showcase` | Creates the system users. |
| `::data_showcase::config` | Generates the application configuration. |
| `::data_showcase::service` | Installs the `data-showcase` service. |
| `::data_showcase::complete` | Installs all of the above. |
| `::data_showcase::database` | Installs `postgresql` with the database admin credentials. |


### Module parameters

Overview of the parameters that can be used in Hiera to configure the module.
Alternatively, the parameters of the `::transmart_core::params` class can be used to configure these settings.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `data_showcase::version` | `1.0.3` | The version of the data showcase to install. |
| `data_showcase::nexus_url` | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `data_showcase::repository` | `releases` | The repository to use. [`snapshots`, `releases`] |
| `data_showcase::user` | `datashowcase` | System user that runs the application. |
| `data_showcase::user_home` | `/home/${user}` | The user home directory |
| `data_showcase::db_user` | | The database admin username. (Mandatory) |
| `data_showcase::db_password` | | The database admin password. (Mandatory) |
| `data_showcase::db_host` | `localhost` | The database server host name. |
| `data_showcase::db_port` | `5432` | The database server port. |
| `data_showcase::db_name` | `datashowcase` | The database name. |
| `data_showcase::access_token` | | Access token for loading data. (Mandatory) |
| `data_showcase::memory` | `2g` | The memory limit for the JVM. |
| `data_showcase::app_port` | `8080` | The port the `data-showcase` application runs on. |
| `data_showcase::environment` | `Public` | The environment to configure the system for [`Public`, `Internal`]. |
| `data_showcase::vu_logo_file` | | File name of the logo to use. The logo should be in `${user_home}/images`. |
| `data_showcase::ntr_logo_file` | | File name of the logo to use. The logo should be in `${user_home}/images`. |


## Images
The example image in [files](files) is [a painting by Frans Francken the Younger](https://commons.wikimedia.org/wiki/File:Frans_Francken_the_Younger_-_The_cabinet_of_a_collector_with_paintings,_shells,_coins,_fossils_and_flowers_-_1619.jpg).

## License

Copyright &copy; 2017&ndash;2018  The Hyve.

The puppet module for TranSMART is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](LICENSE) along with this program. If not, see https://www.gnu.org/licenses/.
