# Copyright 2017 The Hyve.
class data_showcase::complete inherits data_showcase::params {
    include ::data_showcase
    include ::data_showcase::config
    include ::data_showcase::service
}

