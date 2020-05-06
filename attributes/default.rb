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

default[:chef_splunk][:user_seed][:username] = 'admin'
default[:chef_splunk][:user_seed][:hash] = ''

# Type can be forwarder, heavy, enterprise
# Only forwarder implemented at this time
default[:chef_splunk][:type] = 'forwarder'
default[:chef_splunk][:version] = '8.0.1'
default[:chef_splunk][:build] = '6db836e2fb9e'

# Forwarder Default '/opt/splunkforwarder'
# Enterprise Default '/opt/splunk'
default[:chef_splunk][:home] = '/opt/splunkforwarder'

default[:chef_splunk][:package_path] = "/root"

default[:chef_splunk][:accept_license] = true

default[:chef_splunk][:implementation_cookbook] = 'org_splunk'
