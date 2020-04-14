# Install a SSL cert using PEM format. Windows only.
define sslcertificate::from_pem($cert_content, $key_content, $store = 'LocalMachine\My', $exportable = false, $remove_expired_certs = true) {

  require ::sslcertificate::openssl

  if ($exportable) {
    $exportable_flag = "-Exportable"
  } else {
    $exportable_flag = ""
  }

  exec { "${title}-install-to-${store}":
    provider  => powershell,
    command   => template('sslcertificate/import_from_pem.ps1.erb'),
    onlyif    => template('sslcertificate/should_import_from_pem.ps1.erb'),
    logoutput => true,
  }

  if $remove_expired_certs {
    exec { "${title}_RemoveExpiredCerts":
      provider  => 'powershell',
      command   => template('sslcertificate/remove_expired_certs.ps1.erb'),
      onlyif    => template('sslcertificate/should_remove_expired_certs.ps1erb'),
      logoutput => true,
    }
  }

}
