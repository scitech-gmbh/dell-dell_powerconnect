Puppet::Type.newtype(:powerconnect_backup) do

  @doc = "Backup running-config and startup-config of PowerConnect switch"

  apply_to_device

  newparam(:name) do
    isnamevar
  end

  newparam(:url) do
    desc = "Defines the TFTP path where the switch configuration is backed up"
    validate do |url|
      raise ArgumentError, "Url must be in the format tftp://${deviceRepoServerIPAddress}/${fileLocation} " unless url.is_a? String
      raise ArgumentError, "The backup file has to end with .scr" unless url.end_with?('.scr')
      raise ArgumentError, "Tftp is the only supported file transfer protocol" unless url.start_with?('tftp://')
    end
  end

  newparam(:config_type) do
    desc "Specifies whether the provided configuration is startup or running"
    newvalues(/((\bstartup\b)|(\brunning\b))/)
  end

  newproperty(:returns, :event => :executed_command) do |property|
    munge do |value|
      value.to_s
    end

    def event_name
      :executed_command
    end

    defaultto "#"

    def change_to_s(currentvalue, newvalue)
      Puppet.debug "currentvalue = #{currentvalue} newvalue = #{newvalue}"
      "executed successfully"
    end

    def retrieve

    end

    def sync

      event = :executed_command
      provider.run(self.resource[:url], self.resource[:config_type])
      event
    end
  end

  @isomorphic = false

  def self.instances
    []
  end
end
