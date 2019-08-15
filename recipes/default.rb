#
# Cookbook:: mongo
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.




# package 'mongodb-org' do
#   #action [:install,:upgrade]
#   options "--allow-unauthenticated"
#   action :install
# end

# package 'mongodb-org' do
#   #action [:install,:upgrade]
#   action :upgrade
#   options "--allow-unauthenticated"
# end

apt_update 'update_sources' do
  action :update
end

apt_repository 'mongodb-org' do
    uri "http://repo.mongodb.org/apt/ubuntu"
    distribution 'trusty/mongodb-org/3.2'
    components ['multiverse']
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'EA312927'
    action :add
end

directory '/data/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/data/db/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  mode '0755'
  owner 'root'
  group 'root'
  #notifies :restart, 'service[mongod]'  #to restart nginx once proxy_port is changed
end

template '/etc/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'  #to restart nginx once proxy_port is changed
end

package 'mongodb-org' do
  #action [:install,:upgrade]
  options "--allow-unauthenticated"
  action :install
end

service 'mongod' do
  # supports status: true, start: true, restart: true, reload: true, enable: true
  # options "--allow-unauthenticated"
  action [:enable, :start]
end


# link '/etc/mongodb//proxy.conf' do
#   to '/etc/nginx/sites-available/proxy.conf'
# end
#
# link '/etc/nginx/sites-enabled/default' do
#   action :delete
#   notifies :restart, 'service[nginx]'  #restart nginx when provision file is changed
# end
