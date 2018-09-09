Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  # define the provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  config.vm.define "octo"
  config.vm.hostname = "octo"
#  setup private network for the VM
  config.vm.network "private_network", ip: "192.168.33.12"
end
