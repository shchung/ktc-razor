#
# Cookbook Name:: ktc-razor
# Recipe:: default
#

tags = node['razor']['tags'] || Hash.new

tags.each_pair do |name, tag|
  razor_tag name do
    %w[type url version checksum].each do |attr|
      send(attr, tag[attr]) if attr
    end

    action tag['action'].to_sym if tag['action']
  end
end
