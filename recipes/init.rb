#
# Cookbook:: chef_splunk
# Recipe:: init
#
# Copyright:: 2018, The Authors, All Rights Reserved.


if node[:chef_splunk][:accept_license]
  init_start_command = "#{node[:chef_splunk][:home]}/bin/splunk start --accept-license --answer-yes"
else
  init_start_command = "#{node[:chef_splunk][:home]}/bin/splunk start"
end

execute 'initial_splunk_start' do
  command init_start_command
  only_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
  user 'splunk'
  group 'splunk'
end

execute 'start_splunk_on_boot' do
  command "#{node[:chef_splunk][:home]}/bin/splunk enable boot-start"
  not_if do ::File.exists?('/etc/init.d/splunk') end
end

