# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$master = <<SCRIPT
service iptables stop
sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf
rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum install -y salt-master
chkconfig salt-master on
service salt-master start
echo "10.11.12.101   minion" >> /etc/hosts
SCRIPT

$minion = <<SCRIPT
service iptables stop
sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf
rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum install -y salt-minion
chkconfig salt-minion on
service salt-minion start
echo "10.11.12.100   salt" >> /etc/hosts
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :master do |master|
    master.vm.box      = "centos-64-64"
    master.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    master.vm.hostname = "salt"
    master.vm.network :private_network, ip: "10.11.12.100"

    master.vm.provision "shell", inline: $master

    master.vm.provider "virtualbox" do |v|
      v.name = "Salt Master"
      v.gui  = true
      v.customize ["modifyvm", :id, "--memory", 512]
    end
  end

  config.vm.define :minion do |minion|
    minion.vm.box      = "centos-64"
    minion.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    minion.vm.hostname = "minion"
    minion.vm.network :private_network, ip: "10.11.12.101"

    minion.vm.provision "shell", inline: $minion

    minion.vm.provider "virtualbox" do |v|
      v.name = "Salt Minion"
      v.gui  = true
      v.customize ["modifyvm", :id, "--memory", 512]
    end
  end
end
