# Class: data_showcase
# ===========================
#
# Full description of class data_showcase here.
#
# Parameters
# ----------
#
# * `params::user`
# The system user to be created that runs the application (default: datashowcase).
#
# * `params::user_home`
# The home directory where the application files are stored (default: /home/${user}).
#
# * `params::version`
# Version of the data showcase artefacts in Nexus (default: 0.0.1-SNAPSHOT).
#
# * `params::nexus_url`
# The url of the repository to fetch the artefacts from
# (default: https://repo.thehyve.nl).
#
# * `params::db_user`
# The database user. Required.
#
# * `params::db_password`
# The database user's password. Required.
#
# * `params::db_host`
# The hostname of the database server (default: localhost).
#
# * `params::db_port`
# The port of the database server (default: 5432 if postgres, 1521 if oracle).
#
# * `params::db_name`
# The name of the application database (default: data-showcase).
#
# * `params::access_token`
# The access token for uploading data. Required.
#
# * `params::java_package`
# The name of the Java package to install (default: openjdk-8-jdk)
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
        package => $::data_showcase::params::java_package,
    }

}

