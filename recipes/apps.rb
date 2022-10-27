#
# Cookbook Name:: chef_splunk
# Recipe:: apps
#
# Copyright (c) 2017 Chris White, MIT License
#

if ::File.exist?('/etc/systemd/system/SplunkForwarder.service')
  file '/etc/init.d/splunk' do
    action :delete
  end
end

splunk_service = 'SplunkForwarder'

# else
#   splunk_service = 'splunk'
# end

node[:chef_splunk][:apps].each_key do |splunk_app|

  if splunk_app == 'system'
    splunk_conf_base = 'etc'
  else
    splunk_conf_base = 'etc/apps'
  end

  if node[:chef_splunk][:apps][splunk_app][:enabled]

    directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}" do
      owner node[:chef_splunk][:splunk_user]
      group node[:chef_splunk][:splunk_user]
      mode '0755'
      action :create
      notifies :restart, "service[#{splunk_service}]", :delayed
    end


    if node[:chef_splunk][:apps][splunk_app][:setacl_dirs]
      file "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/.setacl_dirs" do
        action :create
        content node[:chef_splunk][:apps][splunk_app][:setacl_dirs].join(",")
        owner 'root'
        group 'root'
        mode '0640'
        notifies :run, 'execute[setacl_dirs]', :immediately
      end

      execute 'setacl_dirs' do
        command "setfacl -m u:#{node[:chef_splunk][:splunk_user]}:rx #{node[:chef_splunk][:apps][splunk_app][:setacl_dirs].join(" ")}"
        action :nothing
      end
    end

    if node[:chef_splunk][:apps][splunk_app][:setacl_files]
      file "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/.setacl_files" do
        action :create
        content node[:chef_splunk][:apps][splunk_app][:setacl_files].join(",")
        owner 'root'
        group 'root'
        mode '0640'
        notifies :run, 'execute[setacl_files]', :immediately
      end
      
      execute 'setacl_files' do
        command "setfacl -m u:#{node[:chef_splunk][:splunk_user]}:r #{node[:chef_splunk][:apps][splunk_app][:setacl_files].join(" ")}"
        action :nothing
      end
    end


    if node[:chef_splunk][:apps][splunk_app][:conf]
      node[:chef_splunk][:apps][splunk_app][:conf].each_key do |dir|

        directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}" do
          owner node[:chef_splunk][:splunk_user]
          group node[:chef_splunk][:splunk_user]
          mode '0755'
          action :create
          notifies :restart, "service[#{splunk_service}]", :delayed
        end
        

        node[:chef_splunk][:apps][splunk_app][:conf][dir].each_key do |conf|
        
          if node[:chef_splunk][:confseed] && 
            node[:chef_splunk][:confseed][splunk_app] && 
            node[:chef_splunk][:confseed][splunk_app][:conf] && 
            node[:chef_splunk][:confseed][splunk_app][:conf][dir] && 
            node[:chef_splunk][:confseed][splunk_app][:conf][dir][conf]

            template "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}/#{conf}" do
              source 'confs.erb'
              owner node[:chef_splunk][:splunk_user]
              group node[:chef_splunk][:splunk_user]
              mode '0644'
              variables({
                :splunk_app => splunk_app,
                :splunk_conf_base => splunk_conf_base,
                :dir => dir,
                :conf => conf,
                :stanzas => node[:chef_splunk][:apps][splunk_app][:conf][dir][conf]
              })
              notifies :restart, "service[#{splunk_service}]", :delayed
              not_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}/#{conf}") end
            end

          else

            template "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/#{dir}/#{conf}" do
              source 'confs.erb'
              owner node[:chef_splunk][:splunk_user]
              group node[:chef_splunk][:splunk_user]
              mode '0644'
              variables({
                :splunk_app => splunk_app,
                :splunk_conf_base => splunk_conf_base,
                :dir => dir,
                :conf => conf,
                :stanzas => node[:chef_splunk][:apps][splunk_app][:conf][dir][conf]
              })
              notifies :restart, "service[#{splunk_service}]", :delayed
            end
          end
        end
      end
    end

    # Loop through bin list of <filename> from app attributes definition
    # Expecting template in implementation cookbook templates/<app_name>/<filename>.erb
    if node[:chef_splunk][:apps][splunk_app][:bin]
      directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/bin" do
        owner node[:chef_splunk][:splunk_user]
        group node[:chef_splunk][:splunk_user]
        mode '0755'
        action :create
        notifies :restart, "service[#{splunk_service}]", :delayed
      end
    
      node[:chef_splunk][:apps][splunk_app][:bin].each do | bin_file |
        template "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/bin/#{bin_file}" do
          source "#{splunk_app}/#{bin_file}.erb"
          cookbook "#{node[:chef_splunk][:implementation_cookbook]}"
          owner node[:chef_splunk][:splunk_user]
          group node[:chef_splunk][:splunk_user]
          mode '0744'
        end
      end
    end

    # Loop through lookups list of <filename> from app attributes definition
    # Expecting template in implementation cookbook templates/<app_name>/<filename>.erb
    if node[:chef_splunk][:apps][splunk_app][:lookups]
      directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/lookups" do
        owner node[:chef_splunk][:splunk_user]
        group node[:chef_splunk][:splunk_user]
        mode '0755'
        action :create
        notifies :restart, "service[#{splunk_service}]", :delayed
      end
    
      node[:chef_splunk][:apps][splunk_app][:lookups].each do | lookups_file |
        template "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/lookups/#{lookups_file}" do
          source "#{splunk_app}/#{lookups_file}.erb"
          cookbook "#{node[:chef_splunk][:implementation_cookbook]}"
          owner node[:chef_splunk][:splunk_user]
          group node[:chef_splunk][:splunk_user]
          mode '0644'
          not_if do ::File.exists?("#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}/lookups/#{lookups_file}") end
        end
      end
    end

  else

    if splunk_app != 'system'
      directory "#{node[:chef_splunk][:home]}/#{splunk_conf_base}/#{splunk_app}" do
        recursive true
        action :delete
        notifies :restart, "service[#{splunk_service}]", :delayed
      end
    end
    
  end
end

service splunk_service do
  action :nothing
  not_if do ::File.exists?("#{node[:chef_splunk][:home]}/ftr") end
end

