# Manage the ACL on the certificate private key
#
# [*identity*]
# The user identity to grant permission to
#
# [*cert_thumbprint*]
# Thumbprint of the cert to set the ACL for
#
# [*store*]
# The certificate store to search
#
# [*permission*]
# What permission to apply. Defaults to Read
#
# [*type*]
# What permission type to set. Default to Allow
#
define sslcertificate::key_acl (
  String $identity,
  String $cert_thumbprint,
  String $store = "LocalMachine\\My",
  String $permission = 'Read',
  String $type = 'Allow'
) {
  exec { "Set ACL for ${title}":
    provider  => 'powershell',
    command   => template('sslcertificate/set_acl_on_private_key.ps1.erb'),
    onlyif    => template('sslcertificate/should_set_acl_on_private_key.ps1.erb'),
    logoutput => true,
  }
}
