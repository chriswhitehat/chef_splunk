#
# Cookbook Name:: chef_splunk
# Recipe:: client
#
# Copyright (c) 2017 Chris White, MIT License
#

remote_file '/tmp/splunkforwarder.deb' do
  owner 'root'
  group 'root'
  mode '0644'
  source node[:chef_splunk][:forwarder][:url]
  action :create_if_missing
end

dpkg_package 'splunkforwarder' do
  source '/tmp/splunkforwarder.deb'
end


include_recipe 'chef_splunk::apps'


if node[:chef_splunk][:accept_license]
  init_start_command = "#{node[:chef_splunk][:home]}/bin/splunk start --accept-license"
else
  init_start_command = "#{node[:chef_splunk][:home]}/bin/splunk start"
end

execute 'initial_splunk_start' do
  command init_start_command
  only_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
  user 'splunk'
  group 'splunk'
end

execute 'start_splunk_on_boot' do
  command "#{node[:chef_splunk][:home]}/bin/splunk enable boot-start"
  not_if do ::File.exists?('/etc/init.d/splunk') end
end


