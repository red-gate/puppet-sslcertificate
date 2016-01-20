# puppet-sslcertificate
Module to manage SSL Certificates on Windows Server 2012+

Originally started as a fork of https://github.com/voxpupuli/puppet-sslcert
but ended up dropping support for Windows Server 2008 and use Server 2012+ `Import-PfxCertificate` cmdlet instead.

## How to build
This only works on non windows box. (because rspec-puppet-init?)
```
bundle install
bundle exec rspec-puppet-init
bundle exec spec
```
