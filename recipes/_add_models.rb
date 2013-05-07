#
# Cookbook Name:: ktc-razor
# Recipe:: default
#

models = node['razor']['tags'] || Hash.new

models.each_pair do |name, tag|
  razor_model name do
    %w[type url version checksum].each do |attr|
      send(attr, tag[attr]) if attr
    end

    action model['action'].to_sym if model['action']
  end
end
