# Cookbook Name:: ktc-razor
# Recipe:: default


include_recipe 'git'
include_recipe 'build-essential'

include_recipe 'razor::_tftp'
include_recipe 'razor::_tftp_files'
include_recipe 'razor::_mongodb'
include_recipe 'razor::_postgresql'
include_recipe 'razor::_nodejs'
include_recipe 'razor::_ruby_from_package'
include_recipe 'razor::_app'
include_recipe 'razor::_add_images'
include_recipe 'ktc-razor::_add_tags'
include_recipe 'ktc-razor::_model_template_add'
include_recipe 'ktc-razor::_add_models'
