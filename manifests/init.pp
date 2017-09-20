# Class: data_showcase
# ===========================
#
# Full description of class data_showcase here.
#
# Parameters
# ----------
#
# * `user`
# The system user to be created that runs the application (default: datashowcase).
#
# * `user_home`
# The home directory where the application files are stored (default: /home/${user}).
#
# * `version`
# Version of the data showcase artefacts in Nexus (default: 0.0.1-SNAPSHOT).
#
# * `nexus_url`
# The url of the repository to fetch the artefacts from
# (default: https://repo.thehyve.nl).
#
# * `db_user`
# The database user. Required.
#
# * `db_password`
# The database user's password. Required.
#
# * `db_host`
# The hostname of the database server (default: localhost).
#
# * `db_port`
# The port of the database server (default: 5432 if postgres, 1521 if oracle).
#
# * `db_name`
# The name of the application database (default: data-showcase).
#
# Examples
# --------
#
# @example
#    class { '::data_showcase':
#        environment => 'Public',
#    }
#
# Authors
# -------
#
# Gijs Kant <gijs@thehyve.nl>
#
# Copyright
# ---------
#
# Copyright 2017 The Hyve.
#
class data_showcase inherits data_showcase::params {

    $user = $::data_showcase::params::user
    $home = $::data_showcase::params::dsuser_home

    # Create datashowcase user.
    user { $user:
        ensure     => present,
        home       => $home,
        managehome => true,
    }
    # Make home only accessible for the user
    -> file { $home:
        ensure => directory,
        mode   => '0711',
        owner  => $user,
    }

    class { '::java':
        package => hiera('java::package', 'openjdk-8-jdk'),
    }

}

