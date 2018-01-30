#
# Cookbook:: chef_splunk
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'chef_splunk::install'
include_recipe 'chef_splunk::apps'
include_recipe 'chef_splunk::init'
