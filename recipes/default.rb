#
# Cookbook:: citius_testslave
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

windows_package 'install JDK 1.8u121' do
  source node['java']['windows']['url']
  installer_type :custom
  action :install
end

windows_path 'C:\Program Files\Java\jdk1.8.0_121\bin' do
  action :add
end

env 'JAVA_HOME' do
  value 'C:\\Program Files\\Java\\jdk1.8.0_121'
  notifies :reboot_now, 'reboot[now]', :delayed
end

reboot 'now' do
  action :nothing
  reason 'needs reboot after setting JAVA_HOME.'
  delay_mins 1
end

include_recipe 'git'
include_recipe 'chrome'
include_recipe 'firefox'
include_recipe 'chromedriver'

tag('slave')
ruby_block 'set `slave_labels` node attributes to test-server' do
  block do
    node.normal['slave_labels'] = 'test-server'
    node.save
  end
end

include_recipe 'citius_jenkins::install_slave'