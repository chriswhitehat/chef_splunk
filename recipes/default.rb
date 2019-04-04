#
# Cookbook:: chef_splunk
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'chef_splunk::install'
include_recipe 'chef_splunk::apps'
include_recipe 'chef_splunk::init'


if ::File.exist?('/etc/systemd/system/SplunkForwarder.service')
  splunk_service = 'SplunkForwarder'
else
  splunk_service = 'splunk'
end

service splunk_service do
  action :start
end
