require "erb"

# Root ProjectRazor namespace
module ProjectRazor
  module ModelTemplate
    # Root Model object
    # @abstract
    class UbuntuPreciseKTCIP < Ubuntu
      include(ProjectRazor::Logging)

      def initialize(hash)
        super(hash)
        # Static config
        @hidden          = false
        @name            = "ubuntu_precise_ktc_ip"
        @description     = "Ubuntu Precise Model (KTC IP Pool)"
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
        @osversion       = 'precise_ktc_ip'
        @final_state     = :os_complete
        @ip_range_network        = nil
        @ip_range_subnet         = nil
        @ip_range_start          = nil
        @ip_range_end            = nil
        @gateway                 = nil
        @hostname_prefix         = nil
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
          "@ip_range_network_service"        => { :default     => "",
                                                  :example     => "192.168.10",
                                                  :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                                  :required    => true,
                                                  :description => "Service IP Network for hosts" },
          "@ip_range_subnet_service"         => { :default     => "255.255.255.0",
                                                  :example     => "255.255.255.0",
                                                  :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                                  :required    => true,
                                                  :description => "Service IP Subnet" },
          "@ip_range_start_service"          => { :default     => "",
                                                  :example     => "1",
                                                  :validation  => '^\b(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                                  :required    => true,
                                                  :description => "Starting Service IP address (1-254)" },
          "@ip_range_end_service"            => { :default     => "",
                                                  :example     => "50",
                                                  :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                                  :required    => true,
                                                  :description => "Ending Service IP address (2-255)" },
          "@ip_range_network_storage"        => { :default     => "",
                                                  :example     => "192.168.10",
                                                  :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                                  :required    => true,
                                                  :description => "Storage IP Network for hosts" },
          "@ip_range_subnet_storage"  => { :default     => "255.255.255.0",
                                           :example     => "255.255.255.0",
                                           :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                           :required    => true,
                                           :description => "storage IP Subnet" },
          "@ip_range_start_storage"          => { :default     => "",
                                                  :example     => "1",
                                                  :validation  => '^\b(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                                  :required    => true,
                                                  :description => "Starting storage IP address (1-254)" },
          "@ip_range_end_storage"            => { :default     => "",
                                                  :example     => "50",
                                                  :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                                  :required    => true,
                                                  :description => "Ending storage IP address (2-255)" },
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
          "@ip_range_start_mgmt"          => { :default     => "",
                                               :example     => "1",
                                               :validation  => '^\b(25[0-4]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                               :required    => true,
                                               :description => "Starting MGMT IP address (1-254)" },
          "@ip_range_end_mgmt"            => { :default     => "",
                                               :example     => "50",
                                               :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                                               :required    => true,
                                               :description => "Ending MGMT IP address (2-255)" },
          "@gateway_mgmt"                 => { :default     => "",
                                               :example     => "192.168.1.1",
                                               :validation  => '^\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b$',
                                               :required    => true,
                                               :description => "Gateway for node" }
        }

        from_hash(hash) unless hash == nil
      end

      def node_ip_address_service
        "#{@ip_range_network_service}.#{(@ip_range_start_service..@ip_range_end_service).to_a[@counter - 1]}"
      end
      def node_ip_address_mgmt
        "#{@ip_range_network_mgmt}.#{(@ip_range_start_mgmt..@ip_range_end_mgmt).to_a[@counter - 1]}"
      end
      def node_ip_address_storage
        "#{@ip_range_network_storage}.#{(@ip_range_start_storage..@ip_range_end_storage).to_a[@counter - 1]}"
      end
      def hostname
        "#{@hostname_prefix}#{@counter.to_s.rjust(2,'0')}#{@hostname_postfix}"
      end

    end
  end
end