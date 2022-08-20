# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
'rocky-srv' => {'memory' => '1024', 'cpus' => '1', 'ip' => '12', 'box' => 'rockylinux/8'},
#'debian-srv' => {'memory' => '1024', 'cpus' => '1', 'ip' => '13', 'box' => 'debian/buster64'},
#'ubuntu-srv' => {'memory' => '1024', 'cpus' => '1', 'ip' => '14', 'box' => 'ubuntu/focal64'},
}

Vagrant.configure('2') do |config|
  vms.each do |name, conf|
     config.vm.define "#{name}" do |my|
       my.vm.box = conf['box']
       my.vm.hostname = "#{name}.example.com"
       my.vm.network 'private_network', ip: "192.168.33.#{conf['ip']}"
       my.vm.provision "ansible" do |ansible|
          ansible.playbook = "zabbix.yml"
       end
       my.vm.provider 'virtualbox' do |vb|
          vb.memory = conf['memory']
          vb.cpus = conf['cpus']
       end
     end
  end
end