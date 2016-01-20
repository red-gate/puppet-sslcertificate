require 'spec_helper'

describe 'sslcertificate', :type => :define do
  describe 'when managing a ssl certificate' do
    let(:title) { 'certificate-testCert' }
    let(:params) { {
      :file       => 'C:\SslCertificates\testCert.pfx',
      :password   => 'testPass',
      :thumbprint => '07E5C1AF7F5223CB975CC29B5455642F5570798B',
      :store      => 'LocalMachine\My',
    } }

    it do
      should contain_exec('Install-C:\SslCertificates\testCert.pfx-SSLCert-to-LocalMachine\My').with(
        'provider'  => 'powershell',
        'onlyif'    => "if( Test-Path 'Cert:\\LocalMachine\\My\\07E5C1AF7F5223CB975CC29B5455642F5570798B' ) { exit 1 }",
        'logoutput' => 'true'
      )
    end
  end

  describe 'when no certificate thumbprint is provided' do
    let(:title) { 'certificate-testCert' }
    let(:params) { {
      :file       => 'C:\SslCertificates\testCert.pfx',
      :password   => 'testPass',
      :store      => 'LocalMachine\My',
    }}

    it { expect { should contain_exec('Install-C:\SslCertificates\testCert.pfx-SSLCert-to-LocalMachine\My') }.to raise_error(Puppet::Error) }
  end
end
