# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$master = <<SCRIPT
service iptables stop
chkconfig iptables off
sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y salt-master salt-minion --enablerepo=epel-testing
echo "file_roots:"             >> /etc/salt/master
echo "  base:"                 >> /etc/salt/master
echo "    - /srv/salt/states"  >> /etc/salt/master
echo "pillar_roots:"           >> /etc/salt/master
echo "  base:"                 >> /etc/salt/master
echo "    - /srv/salt/pillars" >> /etc/salt/master
echo "custom_tags:"            >> /etc/salt/grains
echo "  - environment: prd"    >> /etc/salt/grains
service salt-master start
chkconfig salt-master on
service salt-minion start
chkconfig salt-minion on
echo "salt-ssh:"             > /etc/salt/roster
echo "  host: 10.11.12.102" >> /etc/salt/roster
echo "  user: vagrant"      >> /etc/salt/roster
echo "  passwd: vagrant"    >> /etc/salt/roster
echo "  sudo: True"         >> /etc/salt/roster
SCRIPT

$minion = <<SCRIPT
service iptables stop
chkconfig iptables off
sed -i s/enabled=1/enabled=0/ /etc/yum/pluginconf.d/fastestmirror.conf
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install -y salt-minion --enablerepo=epel-testing
sed -i 's/\#master\:\ salt/master\:\ 10\.11\.12\.100/' /etc/salt/minion
echo "custom_tags:"           >> /etc/salt/grains
echo "  - environment: dev"   >> /etc/salt/grains
service salt-minion start
chkconfig salt-minion on
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :master do |master|
    master.vm.box      = "centos-64-x64"
    master.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    master.vm.hostname = "salt.localdomain"
    master.vm.network :private_network, ip: "10.11.12.100"

    master.vm.provision "shell", inline: $master
    master.vm.synced_folder "states/", "/srv/salt/states"
    master.vm.synced_folder "pillars/", "/srv/salt/pillars"

    master.vm.provider "virtualbox" do |v|
      v.name = "Salt Master"
      v.gui  = true
      v.customize ["modifyvm", :id, "--memory", 512]
    end
  end

  config.vm.define :minion do |minion|
    minion.vm.box      = "centos-64-x64"
    minion.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    minion.vm.hostname = "minion.localdomain"
    minion.vm.network :private_network, ip: "10.11.12.101"

    minion.vm.provision "shell", inline: $minion

    minion.vm.provider "virtualbox" do |v|
      v.name = "Salt Minion"
      v.gui  = true
      v.customize ["modifyvm", :id, "--memory", 512]
    end
  end

  config.vm.define :ssh do |ssh|
    ssh.vm.box      = "centos-64-x64"
    ssh.vm.box_url  = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    ssh.vm.hostname = "ssh.localdomain"
    ssh.vm.network :private_network, ip: "10.11.12.102"

    ssh.vm.provider "virtualbox" do |v|
      v.name = "Salt SSH"
      v.gui  = true
      v.customize ["modifyvm", :id, "--memory", 512]
    end
  end

end
