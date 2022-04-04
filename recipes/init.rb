#
# Cookbook:: chef_splunk
# Recipe:: init
#
# Copyright:: 2018, The Authors, All Rights Reserved.

splunk_service = 'SplunkForwarder'


if node[:chef_splunk][:accept_license]
  accept_license = "--accept-license --answer-yes"
else
  accept_license = ""
end

if node[:chef_splunk][:user_seed][:hash]
  template "#{node[:chef_splunk][:home]}/etc/system/local/user-seed.conf" do
    source 'user-seed.conf.erb'
    owner node[:chef_splunk][:splunk_user]
    group node[:chef_splunk][:splunk_user]
    mode '0644'
    only_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
  end
end

execute 'start_splunk_on_boot' do
  command "#{node[:chef_splunk][:home]}/bin/splunk enable boot-start -systemd-managed 1 -user #{node[:chef_splunk][:splunk_user]} #{accept_license}; systemctl daemon-reload"
  only_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
  notifies :run, "execute[service_splunk_start]", :immediately
end

file "#{node[:chef_splunk][:home]}/etc/system/local/user-seed.conf" do
  action :delete
  not_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
  sensitive  true
end

execute 'service_splunk_start' do
  command 'service splunk start'
  action :nothing
  notifies :start, "service[#{splunk_service}]"
end

service splunk_service do
  action :nothing
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

