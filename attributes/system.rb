#
# Cookbook Name:: chef_splunk
# Attribute:: app_chef
#
# Copyright (c) 2017 Chris White, MIT License
#

###default[:chef_splunk][:apps][:system][:enabled] = false

##############
# deploymentclient
##############

###deploymentclient = default[:chef_splunk][:apps][:system][:conf][:local]['deploymentclient.conf']

###deploymentclient['target-broker:deploymentServer']['targetUri'] = 'deploy.example.com:8089'

##############
# eventtypes
##############

#eventtypes = default[:chef_splunk][:apps][:system][:conf][:local]['eventtypes.conf']

##############
# indexes
##############

#indexes = default[:chef_splunk][:apps][:system][:conf][:local]['indexes.conf']

##############
# inputs
##############

#inputs = default[:chef_splunk][:apps][:system][:conf][:local]['inputs.conf']

##############
# limits
##############

###limits = default[:chef_splunk][:apps][:system][:conf][:local]['limits.conf']

###limits['thruput']['maxKBps'] = '0' 

###################
# Metadata
###################

#metadata = default[:chef_splunk][:apps][:system][:conf][:metadata]['default.meta']

##############
# outputs
##############

#outputs = default[:chef_splunk][:apps][:system][:conf][:local]['outputs.conf']

##############
# props
##############

#props = default[:chef_splunk][:apps][:system][:conf][:local]['props.conf']

##############
# tags
##############

#tags = default[:chef_splunk][:apps][:system][:conf][:local]['tags.conf']

##############
# transforms
##############

#transforms = default[:chef_splunk][:apps][:system][:conf][:local]['transforms.conf']

