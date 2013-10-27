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
  cookbook_file ::File.join(install_path + "/lib/project_razor/model/ubuntu/", model_file) do
    source model_file
    mode "0644"
  end
end

cookbook_file ::File.join(install_path + "/lib/project_razor/model/", "ubuntu_precise_ktc.rb") do
  source "ubuntu_precise_ktc.rb"
  mode "0644"
end

directory ::File.join(install_path + "/lib/project_razor/model/ubuntu/", "precise_ktc_ip") do
  mode "0755"
end

%w[
	precise_ktc_ip/boot_install.erb
	precise_ktc_ip/boot_local.erb
	precise_ktc_ip/kernel_args.erb
	precise_ktc_ip/os_boot.erb
	precise_ktc_ip/os_complete.erb
	precise_ktc_ip/preseed.erb
].each do |model_file|
  cookbook_file ::File.join(install_path + "/lib/project_razor/model/ubuntu/", model_file) do
    source model_file
    mode "0644"
  end
end

cookbook_file ::File.join(install_path + "/lib/project_razor/model/", "ubuntu_precise_ktc_ip.rb") do
  source "ubuntu_precise_ktc_ip.rb"
  mode "0644"
end

directory ::File.join(install_path + "/lib/project_razor/model/ubuntu/", "precise_lldp") do
  mode "0755"
end

%w[
	precise_lldp/boot_install.erb
	precise_lldp/boot_local.erb
	precise_lldp/kernel_args.erb
	precise_lldp/os_boot.erb
	precise_lldp/os_complete.erb
	precise_lldp/preseed.erb
].each do |model_file|
  cookbook_file ::File.join(install_path + "/lib/project_razor/model/ubuntu/", model_file) do
    source model_file
    mode "0644"
  end
end

cookbook_file ::File.join(install_path + "/lib/project_razor/model/", "ubuntu_precise_lldp.rb") do
  source "ubuntu_precise_lldp.rb"
  mode "0644"
end

directory ::File.join(install_path + "/lib/project_razor/model/ubuntu/", "precise_lldp_mnode") do
  mode "0755"
end

%w[
	precise_lldp_mnode/boot_install.erb
	precise_lldp_mnode/boot_local.erb
	precise_lldp_mnode/kernel_args.erb
	precise_lldp_mnode/os_boot.erb
	precise_lldp_mnode/os_complete.erb
	precise_lldp_mnode/preseed.erb
].each do |model_file|
  cookbook_file ::File.join(install_path + "/lib/project_razor/model/ubuntu/", model_file) do
    source model_file
    mode "0644"
  end
end

cookbook_file::File.join(install_path+"/lib/project_razor/model/", "ubuntu_precise_lldp_mnode.rb")do
  source "ubuntu_precise_lldp_mnode.rb"
  mode "0644"
end
