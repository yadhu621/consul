

default['bwest_consul']['source_location'] = 'http://chefdml.bwe.com/DML/consul/consul_1.0.6_linux_amd64.zip'
default['bwest_consul']['download_destination'] = '/tmp/consul_1.0.6_linux_amd64.zip'

node1_ip_address = '10.90.40.4'
node2_ip_address = '10.90.44.77'
node3_ip_address = '10.90.46.22'

if node['ipaddress'] == node1_ip_address
  default['bwest_consul']['consul_join_ipaddr_1'] = node2_ip_address
  default['bwest_consul']['consul_join_ipaddr_2'] = node3_ip_address
end

if node['ipaddress'] == node2_ip_address
  default['bwest_consul']['consul_join_ipaddr_1'] = node1_ip_address
  default['bwest_consul']['consul_join_ipaddr_2'] = node3_ip_address
end

if node['ipaddress'] == node3_ip_address
  default['bwest_consul']['consul_join_ipaddr_1'] = node1_ip_address
  default['bwest_consul']['consul_join_ipaddr_2'] = node2_ip_address
end