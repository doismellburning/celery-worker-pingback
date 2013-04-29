# -*- mode: ruby -*-
# vi: set ft=ruby :

WORKER_INSTANCES=2

DOMAIN="example.com"

MEMORY=256

# the instances is a hostonly network, this will
# be the prefix to the subnet they use
SUBNET="192.168.2"

Vagrant::Config.run do |config|
  config.vm.define :scheduler do |vmconfig|
    vmconfig.vm.box = "precise32"
    vmconfig.vm.network :hostonly, "#{SUBNET}.10"
    vmconfig.vm.host_name = "scheduler.#{DOMAIN}"
    vmconfig.vm.customize ["modifyvm", :id, "--memory", MEMORY]

    vmconfig.vm.provision :puppet, :options => ["--pluginsync"] do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path = "modules"
      puppet.manifest_file = "site.pp"
    end
  end

  WORKER_INSTANCES.times do |i|
    config.vm.define "worker#{i}".to_sym do |vmconfig|
      vmconfig.vm.box = "precise32"
      vmconfig.vm.network :hostonly, "#{SUBNET}.%d" % (10 + i + 1)
      vmconfig.vm.customize ["modifyvm", :id, "--memory", MEMORY]
      vmconfig.vm.host_name = "worker%d.#{DOMAIN}" % i

      vmconfig.vm.provision :puppet, :options => ["--pluginsync"] do |puppet|
        puppet.manifests_path = "manifests"
        puppet.module_path = "modules"
        puppet.manifest_file = "site.pp"
      end
    end
  end
end
