# Cookbook Name:: ktc-razor
# Recipe:: default

include_recipe 'razor'
include_recipe 'ktc-razor::_add_tags'
include_recipe 'ktc-razor::_model_template_add'
include_recipe 'ktc-razor::_add_models'
