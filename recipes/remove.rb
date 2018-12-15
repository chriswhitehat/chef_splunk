#
# Cookbook:: chef_splunk
# Recipe:: remove
#
# Copyright:: 2018, The Authors, All Rights Reserved.

dpkg_package 'splunkforwarder' do
  action :purge
end
