#
# Cookbook:: chef_splunk
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

if ::File.exist?('/etc/systemd/system/SplunkForwarder.service')
  file '/etc/init.d/splunk' do
    action :delete
  end
end

splunk_service = 'SplunkForwarder'

if node[:chef_splunk][:type] == 'forwarder'
  package_filename = "splunkforwarder-#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}-linux-2.6-amd64.deb"
  download_url = "http://download.splunk.com/products/universalforwarder/releases/#{node[:chef_splunk][:version]}/linux/#{package_filename}"
else
  package_filename = "splunk-#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}-linux-2.6-amd64.deb"
  download_url = 'tbd'
end


version_installed_filename = "#{node[:chef_splunk][:home]}/#{node[:chef_splunk][:version]}-#{node[:chef_splunk][:build]}.installed"


remote_file "#{node[:chef_splunk][:package_path]}/#{package_filename}" do
  owner 'root'
  group 'root'
  mode '0644'
  source download_url
  action :create_if_missing
  not_if do ::File.exists?(version_installed_filename) end
end

service splunk_service do
  action :stop
  not_if do ::File.exists?(version_installed_filename) end
  only_if do ::Dir.exists?(node[:chef_splunk][:home]) end
end

dpkg_package 'splunk' do
  source "#{node[:chef_splunk][:package_path]}/#{package_filename}"
  version "#{node[:chef_splunk][:version]}"
  notifies :run, 'execute[remove_old_installed_files]', :immediately
  notifies :create, 'file[version_installed]', :immediately
  not_if do ::File.exists?(version_installed_filename) end
end

execute 'remove_old_installed_files' do
  command "rm #{node[:chef_splunk][:home]}/*.installed"
  action :nothing
  only_if do ::File.exists?("#{node[:chef_splunk][:home]}/*.installed") end
end

file 'version_installed' do
  path version_installed_filename
  content "#{Time.now.inspect}"
  action :nothing
  owner 'splunk'
  group 'splunk'
  mode '0644'
  notifies :run, 'execute[remove_old_packages]'
end

execute 'remove_old_packages' do
  command 'rm /root/splunk*.deb'
  action :nothing
  only_if do ::File.exists?(version_installed_filename) end
end
