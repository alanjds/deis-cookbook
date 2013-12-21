#
# Cookbook Name:: deis-proxy
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

apt_repository 'nginx-ppa' do
  uri 'http://ppa.launchpad.net/ondrej/nginx/ubuntu'
  distribution node.lsb.codename
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'E5267A6C'
end

package 'nginx'

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :reload, "service[nginx]", :delayed
end

template '/etc/nginx/nginx.conf' do
  user 'root'
  group 'root'
  mode 0644
  source 'nginx.conf.erb'
  notifies :reload, "service[nginx]", :delayed
end

service 'nginx' do
  provider Chef::Provider::Service::Init::Debian
  supports :status => true, :start => true, :stop => true, :reload => true, :restart => true
  action [:enable]
end
