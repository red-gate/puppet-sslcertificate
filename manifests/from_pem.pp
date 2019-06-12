# Install a SSL cert using PEM format. Windows only.
define sslcertificate::from_pem($cert_content, $key_content, $store = 'LocalMachine\My', $exportable = False) {

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

}
