Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |v|
        v.linked_clone = true
        v.memory = 4096
        v.cpus = 4
    end

    config.vm.provision "docker" do |d|
      d.pull_images "ubuntu:18.04"
    end
  end
