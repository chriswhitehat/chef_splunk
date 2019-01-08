#
# Cookbook:: chef_splunk
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.


if node[:chef_splunk][:type] == 'forwarder'
  package_filename = "splunkforwarder-#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}-linux-2.6-amd64.deb"
  download_url = "http://download.splunk.com/products/universalforwarder/releases/#{node[:chef_splunk][:version]}/linux/#{package_filename}"
else
  package_filename = "splunk-#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}-linux-2.6-amd64.deb"
  download_url = 'tbd'
end


version_installed_filename = "#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed"

execute 'remove_old_packages' do
  command 'rm /root/splunk*.deb'
  action :run
  only_if do ::File.exists?(version_installed_filename) end
end

remote_file "#{node[:chef_splunk][:package_path]}/#{package_filename}" do
  owner 'root'
  group 'root'
  mode '0644'
  source download_url
  action :create_if_missing
  not_if do ::File.exists?(version_installed_filename) end
end

dpkg_package 'splunk' do
  source "#{node[:chef_splunk][:package_path]}/#{package_filename}"
  version "#{node[:chef_splunk][:version]}"
  notifies :create, 'file[version_installed]'
  not_if do ::File.exists?(version_installed_filename) end
end

file 'version_installed' do
  path version_installed_filename
  content "#{Time.now.inspect}"
  action :nothing
  owner 'splunk'
  group 'splunk'
  mode '0644'
end

