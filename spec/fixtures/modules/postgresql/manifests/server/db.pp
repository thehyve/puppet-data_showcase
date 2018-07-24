# Define for conveniently creating a role, database and assigning the correct
# permissions. See README.md for more details.
define postgresql::server::db (
    $user,
    $password,
    $comment    = undef,
    $dbname     = $title,
    $encoding   = undef,
    $locale     = undef,
    $grant      = 'ALL',
    $tablespace = undef,
    $template   = 'template0',
    $istemplate = false,
    $owner      = undef
) {
}
