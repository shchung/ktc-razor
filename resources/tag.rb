actions :add, :remove

attribute :name,        :kind_of => String, :name_attribute => true
attribute :tag,         :kind_of => String
attribute :server,		:kind_of => String, :default =>"http://127.0.0.1:8026"
attribute :tag_matcher,	:kind_of => Array

default_action :add
