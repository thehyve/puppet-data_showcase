# Copyright 2017 The Hyve.
class data_showcase::params(
    String[1] $user                         = lookup('data_showcase::user', String, first, 'datashowcase'),
    Optional[String[2]] $user_home          = lookup('data_showcase::user_home', Optional[String], first, undef),
    String[1] $version                      = lookup('data_showcase::version', String, first, '1.0.3'),
    String[1] $nexus_url                    = lookup('data_showcase::nexus_url', String, first, 'https://repo.thehyve.nl'),
    Enum['snapshots', 'releases'] $repository = lookup('data_showcase::repository', Enum['snapshots', 'releases'], first, 'releases'),
    Optional[String[1]] $db_user            = lookup('data_showcase::db_user', Optional[String], first, undef),
    Optional[String[8]] $db_password        = lookup('data_showcase::db_password', Optional[String], first, undef),
    String[1] $db_host                      = lookup('data_showcase::db_host', String, first, 'localhost'),
    Integer $db_port                        = 5432,
    String[1] $db_name                      = lookup('data_showcase::db_name', String, first, 'datashowcase'),

    Optional[String[8]] $access_token       = lookup('data_showcase::access_token', Optional[String], first, undef),

    String[1] $memory                       = lookup('data_showcase::memory', String, first, '2g'),
    Integer[1,65535] $app_port              = lookup('data_showcase::app_port', Integer[1,65535], first, 8080),

    Enum['Public', 'Internal'] $environment = lookup('data_showcase::environment', Enum['Public', 'Internal'], first, 'Public'),
    Optional[String[1]] $vu_logo_file       = lookup('data_showcase::vu_logo_file', Optional[String], first, undef),
    Optional[String[1]] $ntr_logo_file      = lookup('data_showcase::ntr_logo_file', Optional[String], first, undef),
) {

    if ($db_user == undef) {
        fail('No database user specified. Please configure data_showcase::db_user')
    }
    if ($db_password == undef) {
        fail('No database password specified. Please configure data_showcase::db_password')
    }
    if ($access_token == undef) {
        fail('No access token specified. Please configure data_showcase::access_token')
    }

    # Database settings
    $db_url = "jdbc:postgresql://${db_host}:${db_port}/${db_name}"

    # Set datashowcase user home directory
    if $user_home == undef {
        $dsuser_home = "/home/${user}"
    } else {
        $dsuser_home = $user_home
    }

    $config_file = "${dsuser_home}/data-showcase.yml"

    $images_directory = "${dsuser_home}/images"

}
