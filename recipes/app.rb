#Here we'll create fresh rails app with Gemfile and add spree modules.
include_recipe "rvm::system"

package %w(nodejs mysql-devel ImageMagick)  do
  action :install
end

rvm_ruby node['rvm']['user_rubies'] do
  action :install
end

rvm_default_ruby node['rvm']['user_rubies']

rvm_shell "install rails" do
  code %Q{gem install rails --no-rdoc --no-ri -v 4.2.1}
  timeout 36000
  not_if 'gem list | grep rails'
end

rvm_gem "spree_cmd" do
   action :install
end

rvm_shell "Creating new Rails App, rails_url is empty!" do
  code %Q{rails _4.2.1_ new #{node['spree']['app']} --skip-bundle -d #{node['spree']['db_type']}}
  timeout 36000
  cwd node['spree']['root_path']
  user node['spree']['user']
  group node['spree']['group']
  not_if { ::File.exists?("#{node['spree']['app_path']}/Gemfile") }
end

rvm_shell "Adding Spree to Gemfile" do
  code 'spree install --A --skip-install-data'
  timeout 36000
  cwd "#{node['spree']['app_path']}"
  action :nothing
end

rvm_shell "Runing bundle install" do
  code 'bundle install --path .bundle'
  timeout 36000
  cwd "#{node['spree']['app_path']}"
  user node['spree']['user']
  group node['spree']['group']
  not_if 'bundle check'
end

ruby_block "Create devise_key " do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        app_path = node['spree']['app_path']
        command = "cd #{app_path} && bundle exec rake secret"
        command_out = shell_out(command)
        node.set['devise_key'] = command_out.stdout
    end
    action :create
end

template "#{node['spree']['root_path']}/#{node['spree']['app']}/config/initializers/devise.rb" do
  source "devise.erb"
  mode '0600'
  user node['spree']['user']
  group node['spree']['group']
end
