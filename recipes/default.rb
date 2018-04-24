# Cookbook Name : bwest_caogasce_consul
# Recipe        : default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# variables
source_location = node['bwest_consul']['source_location']
download_destination = node['bwest_consul']['download_destination']

# variables necessary to populate config.json template
self_ip_address = node['ipaddress']
consul_join_ipaddr_1 = node['bwest_consul']['consul_join_ipaddr_1']
consul_join_ipaddr_2 = node['bwest_consul']['consul_join_ipaddr_2']
my_hash = {self_ip_address: self_ip_address, consul_join_ipaddr_1: consul_join_ipaddr_1, consul_join_ipaddr_2: consul_join_ipaddr_2}

# download binaries to /tmp
remote_file download_destination do
  source source_location
  owner 'root'
  group 'root'
  action :create_if_missing
end

# unzip binaries
execute 'unzip the binary at /tmp' do
  cwd '/tmp'
  command "unzip #{download_destination}"
  user 'root'
  group 'root'
  umask '022'
  action :run
  not_if { ::File.exist?('/tmp/consul') }
end

# move binaries to /usr/local/bin
execute "move binary to /usr/local/bin/" do
  cwd '/tmp'
  command "mv consul /usr/local/bin/"
  user 'root'
  group 'root'
  umask '022'
  action :run
  not_if { ::File.exist?("/usr/local/bin/consul") }
end

# create a consul user
user 'consul' do
  comment 'system account for consul'
  system true
  shell '/bin/bash'
  action :create
end

# create config directories /etc/consul.d, /etc/consul.d/server and /etc/consul.d/bootstrap
%w{ /etc/consul.d/ /etc/consul.d/server /etc/consul.d/bootstrap }.each do |dir|
  directory dir do
    owner 'consul'
    group 'consul'
    mode '0755'
    action :create
  end
end

# create /var/lib/consul
directory '/var/lib/consul' do
  owner 'consul'
  group 'consul'
  mode '0766'
  recursive true
  action :create
end

# place /etc/consul.d/bootstrap/config.json
template '/etc/consul.d/bootstrap/config.json' do
  source 'bootstrap_config.json.erb'
  owner 'consul'
  group 'consul'
  mode '0644'
  action :create
  variables (my_hash)
end

# place /etc/consul.d/server/config.json
template '/etc/consul.d/server/config.json' do
  source 'server_config.json.erb'
  owner 'consul'
  group 'consul'
  mode '0644'
  action :create
  variables (my_hash)
end

# create sysvinit script
cookbook_file '/etc/rc.d/init.d/consul' do
  source 'sysvinit_consul'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# enable auto-start of consul after a server reboot
execute 'enable consul service' do
  command 'chkconfig consul on'
  action :run
end
