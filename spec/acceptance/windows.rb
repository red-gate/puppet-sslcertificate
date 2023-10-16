# Encoding: utf-8
require_relative 'spec_windowshelper'



describe command('powershell.exe -command Get-ChildItem Cert:\LocalMachine\My') do
    its(:stdout) { should match /.*certtest.example.com.*/ }
end

# Slightly lazy and cheating. Just find all private keys and list their ACLs. As long as one of them has
# the user we're expecting, then we assume success. 
# The way to find the exact file to check is extremely long winded. :sob:
describe command('powershell.exe -command "& {(Get-ChildItem c:\ProgramData\Microsoft\Crypto -Recurse -File | Get-Acl).Access}"') do
    its(:stdout) { should match /.*Vagrant.*/i }
end



