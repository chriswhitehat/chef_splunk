#
# Cookbook:: chef_splunk
# Recipe:: remove
#
# Copyright:: 2018, The Authors, All Rights Reserved.

if node[:chef_splunk][:type] == 'forwarder'
  dpkg_package 'splunkforwarder' do
    action :purge
  end
else
  dpkg_package 'splunk' do
    action :purge
  end
end
