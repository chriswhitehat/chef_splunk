#
# Cookbook Name:: chef_splunk
# Attribute:: default
#
# Copyright (c) 2018 Chris White, MIT License
#


# Pain to update this direct link
# - Go through site to manually download
# - Find wget link
# - Extract version of build
# - /releases/<version>/linux/splunkforwarder-<version>-<build>-linux-2.6-amd64.deb
version = '6.6.2'
build = '4b804538c686'

filename_forwarder = "splunkforwarder-#{version}-#{build}-linux-2.6-amd64.deb"
filename_enterprise = "splunk-#{version}-#{build}-linux-2.6-amd64.deb"

default[:chef_splunk][:type] = 'forwarder'
default[:chef_splunk][:version] = version
default[:chef_splunk][:build] = build

default[:chef_splunk][:forwarder][:home] = '/opt/splunkforwarder'
default[:chef_splunk][:forwarder][:filename] = filename_forwarder
default[:chef_splunk][:forwarder][:url] = "http://download.splunk.com/products/universalforwarder/releases/#{version}/linux/#{filename_forwarder}"


default[:chef_splunk][:enterprise][:home] = '/opt/splunk'
default[:chef_splunk][:enterprise][:filename] = filename_enterprise
default[:chef_splunk][:enterprise][:url] = "http://download.splunk.com/products/splunk/releases/#{version}/linux/#{filename_enterprise}"

default[:chef_splunk][:package_path] = "/root"

default[:chef_splunk][:accept_license] = true

default[:chef_splunk][:implementation_cookbook] = 'org_splunk'
