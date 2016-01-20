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
# [*store*]
# The certifcate store where the certifcate will be installed to
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
define sslcertificate($password, $thumbprint, $file = $title, $store = 'LocalMachine\My') {
  validate_re($thumbprint, '^(.)+$', "Must pass a certificate thumbprint to ${module_name}[${title}]")

  exec { "Install-${file}-SSLCert-to-${store}":
    provider  => powershell,
    command   => template('sslcertificate/import.ps1.erb'),
    onlyif    => "if( Test-Path 'Cert:\\${store}\\${thumbprint}' ) { exit 1 }",
    logoutput => true,
  }
}
