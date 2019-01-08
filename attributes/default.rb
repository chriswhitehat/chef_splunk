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



default[:chef_splunk][:splunk_user] = 'splunk'

# Type can be forwarder, heavy, enterprise
# Only forwarder implemented at this time
default[:chef_splunk][:type] = 'forwarder'
default[:chef_splunk][:version] = '6.6.2'
default[:chef_splunk][:build] = '4b804538c686'

# Forwarder Default '/opt/splunkforwarder'
# Enterprise Default '/opt/splunk'
default[:chef_splunk][:home] = '/opt/splunkforwarder'

default[:chef_splunk][:package_path] = "/root"

default[:chef_splunk][:accept_license] = true

default[:chef_splunk][:implementation_cookbook] = 'org_splunk'
