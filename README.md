# consul

A chef cookbook to install and configure consul.

### Description

The cookbook populates the necessary configuration files required to configure a consul server cluster.

### Usage

Consul can run on three modes.
* Bootstrap - run "consul agent -ui -config-dir /etc/consul.d/bootstrap/config.json" to bootstrap a consul cluster
* Server - run "sudo service consul start" to start consul and join the cluster.
* Client - // to be implemented //

### Note
Update the ipaddresses of the cluster nodes on the attributes file before using cookbook.