# Get openssl.exe, so that we can easily convert PEM certificate/keys to pfx files
class sslcertificate::openssl {
  ensure_resource ('file', "C:\\scripts", { ensure => directory })

  file { 'C:/scripts/openssl.exe':
    source             => 'puppet:///modules/sslcertificate/openssl.exe',
    source_permissions => ignore,
  }
  file { 'C:/scripts/libcrypto-1_1.dll':
    source => 'puppet:///modules/sslcertificate/openssl.exe',
    source_permissions => ignore,
  }
  file { 'C:/scripts/libssl-1_1.dll':
    source => 'puppet:///modules/sslcertificate/openssl.exe',
    source_permissions => ignore,
  }
}
