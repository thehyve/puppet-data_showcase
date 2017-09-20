define archive::nexus (
  $url,
  $gav,
  $repository,
  $ensure          = present,
  $checksum_type   = 'md5',
  $checksum_verify = true,
  $packaging       = 'jar',
  $classifier      = undef,
  $extension       = undef,
  $username        = undef,
  $password        = undef,
  $user            = undef,
  $owner           = undef,
  $group           = undef,
  $mode            = undef,
  $extract         = undef,
  $extract_path    = undef,
  $extract_flags   = undef,
  $extract_command = undef,
  $creates         = undef,
  $cleanup         = undef,
  $proxy_server    = undef,
  $proxy_type      = undef,
  $allow_insecure  = undef,
) {

}