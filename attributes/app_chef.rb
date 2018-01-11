#
# Cookbook Name:: chef_splunk
# Attribute:: app_chef
#
# Copyright (c) 2017 Chris White, MIT License
#

app_name = 'org_chef_chef'

default[:chef_splunk][:apps][app_name][:enabled] = false

##############
# eventtypes
##############

#eventtypes = default[:chef_splunk][:apps][app_name][:conf][:default]['eventtypes.conf']

##############
# indexes
##############

indexes = default[:chef_splunk][:apps][app_name][:conf][:default]['indexes.conf']

# [chef]
indexes['chef']['coldPath'] = '$SPLUNK_DB/chef/colddb'
indexes['chef']['homePath'] = '$SPLUNK_DB/chef/db'
indexes['chef']['thawedPath'] = '$SPLUNK_DB/chef/thaweddb'

##############
# inputs
##############

inputs = default[:chef_splunk][:apps][app_name][:conf][:default]['inputs.conf']

# [monitor:///var/log/chef/client.log]
inputs['monitor:///var/log/chef/client.log']['sourcetype'] = 'chef_client'
inputs['monitor:///var/log/chef/client.log']['index'] = 'chef' 

##############
# limits
##############

#limits = default[:chef_splunk][:apps][app_name][:conf][:default]['limits.conf']

###################
# Metadata
###################

metadata = default[:chef_splunk][:apps][app_name][:conf][:metadata]['default.meta']

# []
metadata['[]']['access'] = 'read : [ * ], write : [ admin ]'
metadata['[]']['access'] = 'read : [ * ], write : [ admin ]'
metadata['[]']['export'] = 'system'

##############
# outputs
##############

#outputs = default[:chef_splunk][:apps][app_name][:conf][:default]['outputs.conf']

##############
# props
##############

props = default[:chef_splunk][:apps][app_name][:conf][:default]['props.conf']

# [chef_client]
props['chef_client']['TZ'] = 'UTC'
props['chef_client']['SHOULD_LINEMERGE'] = 'false'

##############
# tags
##############

#tags = default[:chef_splunk][:apps][app_name][:conf][:default]['tags.conf']

##############
# transforms
##############

#transforms = default[:chef_splunk][:apps][app_name][:conf][:default]['transforms.conf']

