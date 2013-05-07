# Cookbook Name:: razor_tag_LWRP
# Provider:: tag
#
action :add do
  @server_ip = URI.parse(new_resource.server)
  image_uuid = get_image_uuid(new_resource.os_name)
  if image_uuid
    if !model_present?
      add_model(image_uuid)
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.debug("#{new_resource} is already added, so skipping")
     end
  else
    Chef::Log.debug("Image does not exist, so skipping")
  end
end

action :remove do
  @server_ip = URI.parse(new_resource.server)
  model_uuid = model_present?
  if model_uuid
    remove_model(model_uuid)
    new_resource.updated_by_last_action(true)
  else
     Chef::Log.debug("#{new_resource} is already added, so skipping")
  end
end

def get_all_uuid
   get_data("/razor/api/model").fetch("response").map{|x| x['@uuid']}
end

def get_data(url)
  res = Net::HTTP.get(@server_ip + url)
  response_hash = JSON.parse(res)
  return response_hash
end

def model_present?
  get_all_uuid.each do |i|
    get_data("/razor/api/model/#{i}").fetch("response").detect do |x|
       if x['@label'] == new_resource.label # extra data should be compared
          return x['@uuid'] 
       end
    end
  end
  return false
end
###################from bbg-cookbook###################
def razor_bin
  ::File.join(node['razor']['install_path'], "bin/razor")
end

def all_images
  begin
    Mixlib::ShellOut.new("#{razor_bin} image get").
      run_command.
      stdout.
      split("\n\n").
      collect{ |x| Hash[*(x.split(/\n|=>/) - ['Images']).collect{|y| y.strip!}] }
  rescue ArgumentError
    {}
  end
end

def get_image_uuid(imagename)
  all_images.find do |i|
      if  i['OS Name'] == imagename # need more comparison
         return i['UUID']
      end
  end
  return false
end
###################end from bbg-cookbook###################

def add_model(imageuuid)
  label = new_resource.label
  image_uuid = imageuuid
  template  = new_resource.template
  metadata = new_resource.metadata
  json_hash = {"label" => label,
               "image_uuid" => image_uuid,
               "template" => template,
               "req_metadata_hash" => metadata
              }
  json_string = JSON.generate(json_hash)
  res = Net::HTTP.post_form(@server_ip+"/razor/api/model", 'json_hash' => json_string)
  response_hash = JSON.parse(res.body)
  unless res.class == Net::HTTPCreated # POST Response is HTTP Created (201) if successful
     Chef::Log.debug("something wrong")
     raise "Error creating model"
  end
end


def remove_model(uuid)
   http = Net::HTTP.new(@server_ip.host, @server_ip.port)
   request = Net::HTTP::Delete.new("/razor/api/model/#{uuid}")
   res = http.request(request)
   response_hash = JSON.parse(res.body)
   Chef::Log.debug(uuid)
   unless res.class == Net::HTTPAccepted
      raise "Error removing model"
   end
   p response_hash
end
