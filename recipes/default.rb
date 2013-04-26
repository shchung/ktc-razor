
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


#include_recipe 'razor'

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

#ktc_razor_tag "111j112jwhal333332345" do
#        name            "111121121qas3ee3t2stnaerme3"
#        tag             "11111tes3tt3ag333"
#        tag_matcher      [{     "key"=> "memsize",
#                                "compare"=>     "equal",
#                                "value" =>      "1015mb",
#                                "invert" =>     "false"
#                        },
#                        {       "key"=>         "cpu",
#                                "compare"       =>      "equal",
#                                "value" =>      "15mb",
#                                "invert"        =>      "false"
#                        }]
#
#        action  :add
#end
#ktc_razor_tag "1j12jwhal333332345" do
#        name            "11121121qas3ee3t2stnaerme3"
#        tag             "1111tes3tt3ag333"
#        tag_matcher      [{     "key"=> "memsize",
#                                "compare"=>     "equal",
#                                "value" =>      "1015mb",
#                                "invert" =>     "false"
#                        },
#                        {       "key"=>         "cpu",
#                                "compare"       =>      "equal",
#                                "value" =>      "15mb",
#                                "invert"        =>      "false"
#                        }]
#
#        action  :remove
#end
