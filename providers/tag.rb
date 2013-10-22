# Cookbook Name:: razor_tag_LWRP
# Provider:: tag
#

action :add do
  @server_ip = URI.parse(new_resource.server)
  if !tag_present?
    add_tag
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already added, so skipping")
  end
end

action :remove do
  @server_ip = URI.parse(new_resource.server)
  uuid = tag_present?
  if uuid
    remove_tag(uuid)
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("#{new_resource} is already added, so skipping")
  end
end


private

def tag_present?
  get_all_uuid.each do  |i|
    get_data("/razor/api/tag/" + i).fetch("response").detect do |x|
      if x['@name'] === new_resource.name && x['@tag'] === new_resource.tag
        return x['@uuid']
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
  get_data("/razor/api/tag").fetch("response").map { |x| x['@uuid'] }
end

def add_tag
  rule_name =  new_resource.name# Tag Rule name
  tag = new_resource.tag # Tag Rule tag
  json_hash = { "name" => rule_name, "tag" => tag } # Build our Hash
  json_string = JSON.generate(json_hash) # Generate JSON String from Hash
  # POST with our JSON String supplied as the value for 'json_hash"
  res = Net::HTTP.post_form(@server_ip + "/razor/api/tag/", 'json_hash' => json_string)
  unless res.class == Net::HTTPCreated # POST Response is HTTP Created (201) if successful
    raise "Error creating Tag Rule"
  end
  response_hash = JSON.parse(res.body)
  tag_rule_uuid = response_hash["response"].first["@uuid"]
  new_resource.tag_matcher.each do |i|
    json_hash = {
      # We supply the UUID from the Tag Rule above
      "tag_rule_uuid" => tag_rule_uuid,
      "key" =>     i['key'],
      "compare" => i['compare'],
      "value" =>   i['value'],
      "invert" =>  i['invert']
    }
    json_string = JSON.generate(json_hash)
    res = Net::HTTP.post_form(@server_ip +
      "/razor/api/tag/#{tag_rule_uuid}/matcher",
      "json_hash" => json_string)

    unless res.class == Net::HTTPCreated
      raise "Error creating Matcher for Tag Rule #{tag_rule_uuid}"
    end
    response_hash = JSON.parse(res.body)
  end
end


def remove_tag(uuid)
  http = Net::HTTP.new(@server_ip.host, @server_ip.port)
  request = Net::HTTP::Delete.new("/razor/api/tag/#{uuid}")
  res = http.request(request)
  response_hash = JSON.parse(res.body)
  unless res.class == Net::HTTPAccepted
    raise "Error removing Tag"
  end
  p response_hash
end
