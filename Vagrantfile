# -*- mode: ruby -*-
# vi: set ft=ruby :

$PROVISION_SCRIPT = <<SCRIPT
  echo 'StrictHostKeyChecking no' > ~/.ssh/config
  echo 'UserKnownHostsFile=/dev/null no' >> ~/.ssh/config
  apt-add-repository -y ppa:ansible/ansible
  apt-get update -q && apt-get install -y software-properties-common git ansible

  cd /vagrant/cm
  echo 'Install roles:'
  ansible-galaxy install -r requirements.yml --force

  echo 'Run asnible playbook locally:'
  PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook \
    provisioning/dev.yml \
    -i inventory \
    -u vagrant \
    -c local
SCRIPT

Vagrant.configure(2) do |config|
  ram = 1024
  cpu = 2
  dev_ip = '192.168.77.47'

  config.vm.provider 'virtualbox' do |v|
    v.memory = ram
    v.cpus = cpu
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Development VM
  config.vm.define 'dev', primary: true do |dev|
    dev.vm.box = 'ubuntu/trusty64'
    dev.vm.hostname = 'redmine-playbook'
    dev.vm.network 'private_network', ip: dev_ip
    dev.ssh.forward_agent = true
    dev.vm.post_up_message = "Ready to development. Use \'vagrant ssh\' and \'bundle install\' after. \
    \nVirtual machine ip address: #{dev_ip}"

    config.vm.provision "ansible_local" do |ansible|
      ansible.provisioning_path = "/vagrant/cm"
      ansible.playbook = "provisioning/dev.yml"
    end
  end

  # Use vagrant-cachier to cache apt-get, gems and other stuff across machines
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')
end
