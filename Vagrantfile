# -*- mode: ruby -*-
# vi: set ft=ruby :

# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path('../.cache', __FILE__)
guest_cache_path = '/tmp/vagrant-cache'
confucius_root = ENV['CONFUCIUS_ROOT']

unless confucius_root
  warn "[\e[1m\e[31mERROR\e[0m]: Please set the 'CONFUCIUS_ROOT' " +
       'environment variable to point to the confucius repo'
  exit 1
end

::Dir.mkdir(host_cache_path) unless ::Dir.exist?(host_cache_path)


default = {
  :user => ENV['OPSCODE_USER'] || ENV['USER'],
  :project => File.basename(Dir.getwd),

  # AWS stuff
  :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  :keypair => ENV["AWS_USER_KEYPAIR"],
  :ami => "ami-734c6936",
  :region => "us-west-1",
  :instance_type => "m1.medium"
}

VM_NODENAME = "vagrant-#{default[:user]}-#{default[:project]}"

Vagrant.configure("2") do |config|

  config.berkshelf.enable = true

  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.hostname = 'localhost'
  config.omnibus.chef_version = :latest

  # ssh
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb, override|
    # Give enough horsepower to build without taking all day.
    vb.customize [
                  "modifyvm", :id,
                  "--memory", "2048",
                  "--cpus", "2",
                 ]

    config.vm.synced_folder host_cache_path, guest_cache_path
    config.vm.network :forwarded_port, host: 4567, guest: 80, auto_correct: true

  end


  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.data_bags_path = "#{confucius_root}/data_bags"

    _s3_keys = JSON.load(File.new("#{chef.data_bags_path}/aws/s3.json"))

    chef.json = {
        :postgresql => {
            :password => {
                :postgres => 'iloverandompasswordsbutthiswilldo'
            }
        },
        :apt_transport_s3 => {
            :s3 => {
                 :access_key => _s3_keys['aws_access_key_id'],
                 :secret_key => _s3_keys['aws_secret_access_key']
             },
            :deb => {:make => {:enabled => false}},
            :binary => {:copy => true}
        },
        :elasticsearch => {:cluster => {:name => 'elasticsearch_vagrant'}}
    }
    chef.run_list = [
      'recipe[apt]',
      'recipe[java]',
      'recipe[balanced-rabbitmq]',
      'recipe[balanced-elasticsearch]',
      'recipe[balanced-postgres]',
      'recipe[balanced-mongodb]',
      'recipe[balanced-user]',
      'recipe[python-balanced]',
      'recipe[fpm]',
      'recipe[apt_transport_s3]',
      "recipe[#{default[:project]}::dev]"
    ]
  end

end
