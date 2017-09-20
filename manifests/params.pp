# Copyright 2017 The Hyve.
class data_showcase::params(
    String[1] $user                         = hiera('data_showcase::user', 'datashowcase'),
    Optional[String[2]] $user_home          = hiera('data_showcase::user_home', undef),
    String[1] $version                      = hiera('data_showcase::version', '0.0.1-SNAPSHOT'),
    String[1] $nexus_url                    = hiera('data_showcase::nexus_url', 'https://repo.thehyve.nl'),
    String[1] $repository                   = hiera('data_showcase::repository', 'snapsnots'),

    Optional[String[1]] $db_user            = hiera('data_showcase::db_user', undef),
    Optional[String[8]] $db_password        = hiera('data_showcase::db_password', undef),
    String[1] $db_host                      = hiera('data_showcase::db_host', 'localhost'),
    Integer $db_port                        = hiera('data_showcase::db_port', 5432),
    String[1] $db_name                      = hiera('data_showcase::db_name', 'data-showcase'),

    String[1] $memory                       = hiera('data_showcase::memory', '2g'),
    Integer $app_port                       = hiera('data_showcase::app_port', 8080),
    Enum['Public', 'Internal'] $environment = hiera('data_showcase::environment', 'Public'),
) {

    if ($db_user == undef) {
        fail('No database user specified. Please configure data_showcase::db_user')
    }
    if ($db_password == undef) {
        fail('No database password specified. Please configure data_showcase::db_password')
    }

    # Set Nexus location
    $nexus_repository = "${nexus_url}/content/repositories/${repository}/"

    # Database settings
    $postgresql_params = {
        version             => '9.4',
        manage_package_repo => true,
    }
    $db_url = "jdbc:postgresql://${db_host}:${db_port}/${db_name}"

    # Set datashowcase user home directory
    if $user_home == undef {
        $dsuser_home = "/home/${user}"
    } else {
        $dsuser_home = $user_home
    }

}
