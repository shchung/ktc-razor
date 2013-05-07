actions :add, :remove

attribute :label,       :kind_of => String, :name_attribute => true
attribute :server,      :kind_of => String, :default =>"http://127.0.0.1:8026"
attribute :template,    :kind_of => String#, :default =>"ubuntu_precise"
attribute :os_name,  	:kind_of => String#, :default =>"precise64"
attribute :metadata	,	:kind_of => Hash 

default_action :add
