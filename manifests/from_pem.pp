# Install a SSL cert using PEM format. Windows only.
#
# [*cert_content*]
# Contents of the certificate file
#
# [*key_content*]
# Contents of the key file
#
# [*store*]
# Certificate store to import the cert to
#
# [*exportable*]
# Whether the cert should be exportable
#
# [*remove_expired_certs*]
# Whether to remove expired certs
#
define sslcertificate::from_pem (
  String $cert_content,
  String $key_content,
  String $store = 'LocalMachine\My',
  Boolean $exportable = false,
  Boolean $remove_expired_certs = true
) {
  require sslcertificate::openssl

  if ($exportable) {
    $exportable_flag = '-Exportable'
  } else {
    $exportable_flag = ''
  }

  exec { "${title}-install-to-${store}":
    provider  => 'powershell',
    command   => template('sslcertificate/import_from_pem.ps1.erb'),
    onlyif    => template('sslcertificate/should_import_from_pem.ps1.erb'),
    logoutput => true,
  }

  if $remove_expired_certs {
    exec { "${title}_RemoveExpiredCerts":
      provider  => 'powershell',
      command   => template('sslcertificate/remove_expired_certs.ps1.erb'),
      onlyif    => template('sslcertificate/should_remove_expired_certs.ps1.erb'),
      logoutput => true,
    }
  }
}
