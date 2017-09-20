# Copyright 2017 The Hyve.
class data_showcase::database inherits data_showcase::params {
    include ::data_showcase
    include ::data_showcase::config

    class { '::postgresql::globals':
        manage_package_repo => $::data_showcase::params::postgresql_params[manage_package_repo],
        version             => $::data_showcase::params::postgresql_params[version],
    }
    -> class { '::postgresql::server':
    }
    # Create database
    ->  postgresql::server::db { $::data_showcase::params::db_name:
        user     => $::data_showcase::params::db_user,
        password => $::data_showcase::params::db_password,
    }

}
