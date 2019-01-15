# Install a SSL cert using PEM format. Windows only.
define sslcertificate::from_pem($cert_content, $key_content, $store = 'LocalMachine\My') {

  require ::sslcertificate::openssl

  exec { "${title}-install-to-${store}":
    provider  => powershell,
    command   => template('sslcertificate/import_from_pem.ps1.erb'),
    onlyif    => template('sslcertificate/should_import_from_pem.ps1.erb'),
    logoutput => true,
  }

}
