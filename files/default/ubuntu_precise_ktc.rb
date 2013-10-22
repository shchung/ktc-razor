require "erb"

# Root ProjectRazor namespace
module ProjectRazor
  module ModelTemplate
    # Root Model object
    # @abstract
    class UbuntuPreciseKTC < Ubuntu
      include(ProjectRazor::Logging)

      def initialize(hash)
        super(hash)
        # Static config
        @hidden          = false
        @name            = "ubuntu_precise_ktc"
        @description     = "Ubuntu Precise Model for KT-Cloud (MultiDisk)"
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
        @osversion       = 'precise_ktc'
        @final_state     = :os_complete
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
            :example     => "-vm -m",
            :validation  => '^[a-zA-Z0-9][a-zA-Z0-9\-]*$',
            :required    => true,
            :description => "node hostname postfix (will append after node number)"
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
          "@root_disk"        => { :default     => "/dev/sda",
                                   :example     => "/dev/sda",
                                   :validation  => '^[\S]{8,}',
                                   :required    => true,
                                   :description => "Device to install ubuntu"
                                   }
        }

        from_hash(hash) unless hash == nil
      end
      def hostname
        "#{@hostname_prefix}#{@counter.to_s.rjust(2,'0')}#{@hostname_postfix}"
      end
    end
  end
end