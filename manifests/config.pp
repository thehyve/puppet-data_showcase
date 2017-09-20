# Copyright 2017 The Hyve.
class data_showcase::config inherits data_showcase::params {
    include ::data_showcase

    File {
        owner   => $::data_showcase::params::user,
        group   => $::data_showcase::params::user,
        require => User[$::data_showcase::params::user],
    }

    file { $::data_showcase::params::config_file:
        ensure  => file,
        content => template('data_showcase/config/data-showcase.yml.erb'),
        mode    => '0400',
    }

}
