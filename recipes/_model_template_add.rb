#
# Cookbook Name:: ktc-razor
# Recipe:: default
#
#

install_path = node['razor']['install_path']

directory ::File.join(install_path + "/lib/project_razor/model/ubuntu/", "precise_ktc") do
	mode "0755"
end

%w[
	precise_ktc/boot_install.erb
	precise_ktc/boot_local.erb
	precise_ktc/kernel_args.erb
	precise_ktc/os_boot.erb
	precise_ktc/os_complete.erb
	precise_ktc/preseed.erb
].each do |model_file|
	cookbook_file ::File.join(install_path + "/lib/project_razor/model/ubuntu/",model_file) do
		source model_file
		mode "0644"
	end
end

cookbook_file ::File.join(install_path + "/lib/project_razor/model/","ubuntu_precise_ktc.rb") do
	source "ubuntu_precise_ktc.rb"
	mode "0644"
end
