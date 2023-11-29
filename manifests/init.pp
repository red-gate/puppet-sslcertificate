#
# A resource to import certificates from a pfx file to a windows certificate store.
# Windows 2012+ only.
#
# === Parameters
#
# [*password*]
# The password for the given pfx file.
#
# [*thumbprint*]
# The thumbprint used to verify the certifcate
#
# [*file*]
# The name of the file to install. Defaults to the resource title.
#
# [*store*]
# The certifcate store where the certifcate will be installed to
#
# [*exportable*]
# Whether the certificate should be exportable.
#
# === Examples
#
# To install a certificate in the My directory of the LocalMachine root store:
#
#  sslcertificate { "Install-PFX-Certificate" :
#    file       => 'C:\mycert.pfx',
#    password   => 'password123',
#    thumbprint => '07E5C1AF7F5223CB975CC29B5455642F5570798B'
#  }
#
# To install a certifcate in an alterntative direcotory:
#
#  sslcertificate { "Install-Intermediate-Certificate" :
#    file       => 'C:\go_daddy_intermediate.pfx',
#    password   => '1234',
#    store      => 'LocalMachine\CA',
#    thumbprint => '07E5C1AF7F5223CB975CC29B5455642F5570798B'
#  }
define sslcertificate (
  String $password,
  String $thumbprint,
  String $file = $title,
  String $store = 'LocalMachine\My',
  Boolean $exportable = false
) {

  if ($exportable) {
    $exportable_flag = '-Exportable'
  } else {
    $exportable_flag = ''
  }

  exec { "Install-${file}-SSLCert-to-${store}":
    provider  => powershell,
    command   => template('sslcertificate/import.ps1.erb'),
    onlyif    => "if( Test-Path 'Cert:\\${store}\\${thumbprint}' ) { exit 1 }",
    logoutput => true,
  }
}
