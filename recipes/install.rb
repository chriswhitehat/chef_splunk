#
# Cookbook:: chef_splunk
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.


node.default[:chef_splunk][:home] = node[:chef_splunk][node[:chef_splunk][:type]][:home]
node.default[:chef_splunk][:filename] = node[:chef_splunk][node[:chef_splunk][:type]][:filename]
node.default[:chef_splunk][:url] = node[:chef_splunk][node[:chef_splunk][:type]][:url]

remote_file "/tmp/#{node[:chef_splunk][:filename]}" do
  owner 'root'
  group 'root'
  mode '0644'
  source node[:chef_splunk][:url]
  action :create_if_missing
end

dpkg_package 'splunk' do
  source "/tmp/#{node[:chef_splunk][:filename]}"
  notifies :create, 'file[version_installed]'
end

file 'version_installed' do
  path "#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed"
  content "#{Time.now.inspect}"
  action :nothing
  owner 'splunk'
  group 'splunk'
  mode '0644'
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


