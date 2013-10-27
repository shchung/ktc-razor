require "erb"

# Root ProjectRazor namespace
module ProjectRazor
  module ModelTemplate
    # Root Model object
    # @abstract
    class UbuntuPreciseLLDPMnode < Ubuntu
      include(ProjectRazor::Logging)

      def initialize(hash)
        super(hash)
        # Static config
        @hidden          = false
        @name            = "ubuntu_precise_lldp_mnode"
        @description     = "Ubuntu Precise Model with lldp for mnode"
        # Metadata vars
        @hostname_prefix = nil
        # State / must have a starting state
        @current_state   = :init
        # Image UUID
        @image_uuid      = true
        # Image prefix we can attach
        @image_prefix    = "os"
        # Enable agent brokers for this model
        @broker_plugin   = :agent
        @osversion       = 'precise_lldp'
        @final_state     = :os_complete
   #     @ip_range_network        = nil
   #     @ip_range_subnet         = nil
   #     @gateway                 = nil
   #     @hostname_prefix         = nil
   #     @hostname_postfix         = nil
        @req_metadata_hash = {
            "@hostname_prefix" => {
                :default     => "node",
                :example     => "node",
                :validation  => '^[a-zA-Z0-9][a-zA-Z0-9\-]*$',
                :required    => true,
                :description => "node hostname prefix (will append node number)"
            },
            "@hostname_postfix" => {
                :default     => "-m",
                :example     => "-m, -vm",
                :validation  => '^[a-zA-Z0-9\-][a-zA-Z0-9\-]*$',
                :required    => true,
                :description => "node hostname postfix (will append node number)"
            },
            "@domainname"      => {
                :default     => "localdomain",
                :example     => "example.com",
                :validation  => '^[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9](\.[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])*$',
                :required    => true,
                :description => "local domain name (will be used in /etc/hosts file)"
            },
            "@root_password"   => {
                :default     => "test1234",
                :example     => "P@ssword!",
                :validation  => '^[\S]{8,}',
                :required    => true,
                :description => "root password (> 8 characters)"
            },
            "@ip_range_network_mgmt"        => { :default     => "",
                                            :example     => "192.168.10",
                                            :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                            :required    => true,
                                            :description => "MGMT IP Network for hosts" },
            "@ip_range_subnet_mgmt"         => { :default     => "255.255.255.0",
                                            :example     => "255.255.255.0",
                                            :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                            :required    => true,
                                            :description => "MGMT IP subnet" },
            "@dns_nameservers"                  => { :default     => "10.14.0.21",
                                            :example     => "10.14.0.21",
                                            :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                            :required    => true,
                                            :description => "MGMT dns-server" },
#            "@dns_search"              => { :default     => "service01",
#                                            :example     => "service01",
#                                            :validation  => '^[a-zA-Z0-9\-][a-zA-Z0-9\-]*$',
#                                            :required    => true,
#                                            :description => "MGMT dns-search" },
            "@gateway_mgmt"                 => { :default     => "",
                                            :example     => "192.168.1.1",
                                            :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                            :required    => true,
                                            :description => "Gateway for node" }
        }

        from_hash(hash) unless hash == nil
      end
      
      def port_no
         @node.attributes_hash["lldp_neighbor_portid_eth"+mgmt_nic][-3,3].gsub(/[^0-9]/,"").to_i
      end
      def node_ip_address_mgmt
        "#{@ip_range_network_mgmt}."+port_no.to_s
      end
      def hostname
        "#{@hostname_prefix}#{port_no.to_s.rjust(2,'0')}#{@hostname_postfix}"
      end
      def mgmt_nic
       	for i in 1..@node.attributes_hash["mk_hw_nic_count"].to_i 
         	if @node.attributes_hash["lldp_neighbor_sysname_eth"+(i-1).to_s].split( /(?:\s*(?:_|-)\s*)+/)[3] == 'MG'
         	then return (i-1).to_s
         	end
			end
			return '1'
      end
    end
  end
end
