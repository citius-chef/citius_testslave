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

include_recipe 'git'
include_recipe 'chrome'
include_recipe 'firefox'
include_recipe 'chromedriver'
include_recipe 'citius_jenkins::install_slave'

tag('slave')
ruby_block 'set `slave_labels` node attributes to test-server' do
  block do
    node.normal['slave_labels'] = 'test-server'
    node.save
  end
end