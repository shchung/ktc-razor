#
# Cookbook Name:: razor-wrapping
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'razor'

razor_image "razor-mk" do
  type      "mk"
  url       "https://downloads.puppetlabs.com/razor/iso/prod/rz_mk_prod-image.0.12.0.iso"
  action    :add
end
razor_image "precise64" do
  type      "os"
  url       "http://ftp.daum.net/ubuntu-releases/12.04/ubuntu-12.04.2-server-amd64.iso"
  version   "12.04"
end
# test code for tag add
razor_tag "test2345" do
	name		"testname2"
	tag		"testtag2"
	tag_matcher	 [{	"key"=>	"memsize",
				"compare"=>	"equal",
				"value"	=>	"1015mb",
				"invert" =>	"false"
			},
		 	{	"key"=>		"cpu",
				"compare"	=>	"equal",
				"value"	=>	"15mb",
				"invert"	=>	"false"
			}]
				
				
	action 	:add
end
