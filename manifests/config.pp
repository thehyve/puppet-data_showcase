# Copyright 2017 The Hyve.
class data_showcase::config inherits data_showcase::params {
    include ::data_showcase

    $user = $::data_showcase::params::user
    $images_directory = $::data_showcase::params::images_directory
    $example_image_file = 'Frans_Francken_the_Younger_-_The_cabinet_of_a_collector_with_paintings,_shells,_coins,_fossils_and_flowers_-_1619.jpg'

    File {
        owner   => $user,
        group   => $user,
        require => User[$user],
    }

    file { $::data_showcase::params::config_file:
        ensure  => file,
        content => template('data_showcase/config/data-showcase.yml.erb'),
        mode    => '0400',
    }

    file { $images_directory:
        ensure => directory,
        mode   => '0755'
    }
    -> file { "${$images_directory}/example.jpg":
        source => "puppet:///modules/data_showcase/${example_image_file}",
        mode   => '0444',
    }

}
