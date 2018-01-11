#
# Cookbook Name:: chef_splunk
# Attribute:: default
#
# Copyright (c) 2017 Chris White, MIT License
#

default[:chef_splunk][:accept_license] = true

default[:chef_splunk][:home] = '/opt/splunkforwarder'

# Pain to update this direct link, go through site to manually download forwarder, find wget link, replace ../releases/x.x.x/linux/.., and replace filename.
default[:chef_splunk][:forwarder][:url] = 'http://download.splunk.com/products/universalforwarder/releases/6.6.2/linux/splunkforwarder-6.6.2-4b804538c686-linux-2.6-amd64.deb'
#default[:chef_splunk][:forwarder][:url] = 'http://download.splunk.com/products/universalforwarder/releases/7.0.1/linux/splunkforwarder-7.0.1-2b5b15c4ee89-linux-2.6-amd64.deb'


