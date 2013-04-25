# Cookbook Name:: razor_tag_LWRP
# Provider:: tag
#

action :add do
  @server_ip = URI new_resource.server + "/razor/api/"
  if !tag_present?
    add_tag
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already added, so skipping")
  end
end

private

def tag_present?
  get_all_uuid.each do  |i|
     get_data("tag/" + i).fetch("response").detect do |x|
        if x['@name'] === new_resource.name && x['@tag'] === new_resource.tag
           puts "match" + x['@uuid']
           return true
        end
     end
  end
  return false
 end


def get_data(url)
  res = Net::HTTP.get(@server_ip + url)
  response_hash = JSON.parse(res)
  return response_hash
end


def get_all_uuid
  get_data("tag").fetch("response").map{|x| x['@uuid']}
end

def add_tag
   rule_name =  new_resource.name# Tag Rule name
   tag = new_resource.tag # Tag Rule tag
   json_hash = {"name" => rule_name, "tag" => tag} # Build our Hash
   json_string = JSON.generate(json_hash) # Generate JSON String from Hash
   # POST with our JSON String supplied as the value for 'json_hash"
   res = Net::HTTP.post_form(@server_ip + "tag/", 'json_hash' => json_string)
   response_hash = JSON.parse(res.body)
   unless res.class == Net::HTTPCreated # POST Response is HTTP Created (201) if successful
      raise "Error creating Tag Rule"
   end
   tag_rule_uuid = response_hash["response"].first["@uuid"]
   new_resource.tag_matcher.each do |i|
   	json_hash = {"tag_rule_uuid" => tag_rule_uuid, # We supply the UUID from the Tag Rule above
   	             "key" =>     i['key'],
   	             "compare" => i['compare'],
   	             "value" =>   i['value'],
   	             "invert" =>  i['invert']
   	             }
   	json_string = JSON.generate(json_hash)
   	res = Net::HTTP.post_form(@server_ip +"tag/#{tag_rule_uuid}/matcher", 'json_hash' => json_string)
   	response_hash = JSON.parse(res.body)
   	unless res.class == Net::HTTPCreated
   	   raise "Error creating Matcher for Tag Rule #{tag_rule_uuid}"
   	end
  end
end

