actions :add, :remove

attribute :name,        :kind_of => String, :name_attribute => true
attribute :tag,         :kind_of => String
attribute :server,		:kind_of => String, :default =>"http://127.0.0.1:8026"
#attribute :key,         :kind_of => String
#attribute :compare,     :kind_of => String
#attribute :value,       :kind_of => String
#attribute :invert,      :kind_of => String
attribute :tag_matcher,	:kind_of => Array


#def initialize(*args)
#  super
#  @action = :add
#end
default_action :add
