# Copyright 2017 The Hyve.
class data_showcase::database inherits data_showcase::params {
    include ::data_showcase
    include ::data_showcase::config

    include ::postgresql::server

    # Create database
    postgresql::server::db { $::data_showcase::params::db_name:
        user     => $::data_showcase::params::db_user,
        password => $::data_showcase::params::db_password,
    }

}
