# Copyright 2017 The Hyve.
class data_showcase::params(
    String[1] $user                         = 'datashowcase',
    Optional[String[2]] $user_home          = undef,
    String[1] $version                      = '0.0.1-SNAPSHOT',
    String[1] $nexus_url                    = 'https://repo.thehyve.nl',
    Enum['snapshots', 'releases'] $repository = 'snapshots',
    Optional[String[1]] $db_user            = undef,
    Optional[String[8]] $db_password        = undef,
    String[1] $db_host                      = 'localhost',
    Integer $db_port                        = 5432,
    String[1] $db_name                      = 'datashowcase',

    Optional[String[8]] $access_token       = undef,

    String[1] $memory                       = '2g',
    Integer $app_port                       = 8080,

    Enum['Public', 'Internal'] $environment = 'Public',
    Optional[String[1]] $vu_logo_file       = undef,
    Optional[String[1]] $ntr_logo_file      = undef,
    String $java_package                    = 'openjdk-8-jdk',
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
