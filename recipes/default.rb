#
# Cookbook:: chef_splunk
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'chef_splunk::install'
include_recipe 'chef_splunk::apps'
include_recipe 'chef_splunk::init'


if ::File.exist?('/etc/init.d/splunk')
  # Ensure Splunk is up
  service 'splunk' do
    action :start
  end
elsif ::File.exist?('/etc/systemd/system/SplunkForwarder')
  # Ensure Splunk is up
  service 'SplunkForwarder' do
    action :start
  end
end
