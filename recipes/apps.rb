#
# Cookbook Name:: chef_splunk
# Recipe:: apps
#
# Copyright (c) 2017 Chris White, MIT License
#

node[:chef_splunk][:apps].each_key do |splunk_app|

  if node[:chef_splunk][:apps][splunk_app][:enabled]

    if splunk_app == 'system'
      splunk_conf_base = 'etc'
    else
      splunk_conf_base = 'etc/apps'
    end

    directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}" do
      owner 'splunk'
      group 'splunk'
      mode '0755'
      action :create
      notifies :run, 'execute[restart_splunk]', :delayed
    end

    node[:chef_splunk][:apps][splunk_app][:conf].each_key do |dir|

      directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}" do
        owner 'splunk'
        group 'splunk'
        mode '0755'
        action :create
        notifies :run, 'execute[restart_splunk]', :delayed
      end
      

      node[:chef_splunk][:apps][splunk_app][:conf][dir].each_key do |conf|
      
        template "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}/#{conf}" do
          source 'confs.erb'
          owner 'splunk'
          group 'splunk'
          mode '0644'
          variables({
            :splunk_app => splunk_app,
            :splunk_conf_base => splunk_conf_base,
            :dir => dir,
            :conf => conf,
            :stanzas => node[:chef_splunk][:apps][splunk_app][:conf][dir][conf]
          })
          notifies :run, 'execute[restart_splunk]', :delayed
        end
      end
    end

  else

    if splunk_app != 'system'
      directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}" do
        recursive true
        action :delete
        notifies :run, 'execute[restart_splunk]', :delayed
      end
    end
    
  end
end

execute 'restart_splunk' do
  command "#{node[:chef_splunk][:home]}/bin/splunk restart"
  user 'splunk'
  group 'splunk'
  action :nothing
end

