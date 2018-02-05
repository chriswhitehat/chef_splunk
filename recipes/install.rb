#
# Cookbook:: chef_splunk
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.


node.default[:chef_splunk][:home] = node[:chef_splunk][node[:chef_splunk][:type]][:home]
node.default[:chef_splunk][:filename] = node[:chef_splunk][node[:chef_splunk][:type]][:filename]
node.default[:chef_splunk][:url] = node[:chef_splunk][node[:chef_splunk][:type]][:url]


execute 'remove_old_packages' do
  command 'rm /root/splunk*.deb'
  action :run
  not_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed") end
  only_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed") end
end

remote_file "#{node[:chef_splunk][:package_path]}/#{node[:chef_splunk][:filename]}" do
  owner 'root'
  group 'root'
  mode '0644'
  source node[:chef_splunk][:url]
  action :create_if_missing
  not_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed") end
end

dpkg_package 'splunk' do
  source "#{node[:chef_splunk][:package_path]}/#{node[:chef_splunk][:filename]}"
  notifies :create, 'file[version_installed]'
  not_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed") end
end

file 'version_installed' do
  path "#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed"
  content "#{Time.now.inspect}"
  action :nothing
  owner 'splunk'
  group 'splunk'
  mode '0644'
end

