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
  notifies :run, 'execute[start_splunk_on_boot]'
end

execute 'start_splunk_on_boot' do
  command "#{node[:chef_splunk][:home]}/bin/splunk enable boot-start -user #{node[:chef_splunk][:splunk_user]}"
  not_if do ::File.exists?('/etc/init.d/splunk') end
end


# template '/etc/init.d/splunk' do
#   source 'init.d/splunk.erb'
#   owner 'root'
#   group 'root'
#   mode '0644'
#   notifies :run, 'execute[init_and_chown_splunk_home]'
# end

# execute 'init_and_chown_splunk_home' do
#   command "systemctl daemon-reload; sudo service splunk stop; chown -R #{node[:chef_splunk][:splunk_user]}:#{node[:chef_splunk][:splunk_user]} #{node[:chef_splunk][:home]}/; sudo service splunk start"
#   action :nothing
# end

