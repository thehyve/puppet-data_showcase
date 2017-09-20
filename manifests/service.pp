# Copyright 2017 The Hyve.
class data_showcase::service inherits data_showcase::params {
    include ::data_showcase
    include ::data_showcase::config

    $user = $::data_showcase::params::user
    $home = $::data_showcase::params::dsuser_home
    $version = $::data_showcase::params::version
    $environment = $::data_showcase::params::environment
    $application_war_file = "${home}/data-showcase-${version}.war"
    $memory = $::data_showcase::params::memory
    $java_opts = "-server -Xms${memory} -Xmx${memory} -Djava.awt.headless=true "
    $app_port = $::data_showcase::params::app_port
    $config_opts = "-Dspring.config.location=${::data_showcase::params::config_file}"
    $app_opts = "-Dserver.port=${app_port} -Djava.security.egd=file:///dev/urandom ${config_opts}"
    $start_script = "${home}/start"
    $logs_dir = "${home}/logs"

    Archive::Nexus {
        owner   => $user,
        group   => $user,
    }

    # Download the application war
    archive::nexus { $application_war_file:
        user       => $user,
        url        => $::data_showcase::params::nexus_url,
        gav        => "nl.thehyve:data-showcase:${version}",
        repository => $::data_showcase::params::repository,
        packaging  => 'war',
        mode       => '0444',
        creates    => $application_war_file,
        require    => File[$home],
        notify     => Service['data-showcase'],
        cleanup    => false,
    }

    file { $logs_dir:
        ensure => directory,
        owner  => $user,
        mode   => '0700',
    }
    file { $start_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('data_showcase/start.erb'),
        notify  => Service['data-showcase'],
    }
    -> file { '/etc/systemd/system/data-showcase.service':
        ensure  => file,
        mode    => '0644',
        content => template('data_showcase/service/data-showcase.service.erb'),
        notify  => Service['data-showcase'],
    }
    # Start the application service
    -> service { 'data-showcase':
        ensure   => running,
        provider => 'systemd',
        require  => [ File[$logs_dir], Archive::Nexus[$application_war_file] ],
    }

}

