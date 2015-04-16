require 'puppet/util/network_device'
require 'puppet/provider/dell_powerconnect'
require 'puppet/provider/powerconnect_messages'

#begin
#  module_path = Puppet::Module.find('asm_lib', Puppet[:environment].to_s)
#  require File.join module_path.path, 'lib/i18n/AsmException'
#  require File.join module_path.path, 'lib/i18n/AsmLocalizedMessage'
#end

$CALLER_MODULE = "dell_powerconnect"

Puppet::Type.type(:powerconnect_backup).provide :dell_powerconnect, :parent => Puppet::Provider::Dell_powerconnect do

  @doc = "Updates the running-config and startup-config of PowerConnect switch"

  mk_resource_methods

  def initialize(device, *args)
    super
  end

  def self.lookup(device, name)
  end

  def run(url, config_type)
    #begin
    digestlocalfile=''
    digestserverconfig=''
    extBackupConfigfile = ''
    flashtmpfile = 'flash://backup-configtemp.scr'
    backedupPrevConfig = false
    yesflag = false
    txt = ''

	##applying the config only if the md5 mismatches or force option is true
      backupConfig(url, config_type)
  end

  def backupConfig(url, config_type)
    Puppet.info("Copy configuration")
    executeCommand('copy '+ config_type +"-config "+ url,"Are you sure you want to start")
  end

  def executeCommand(cmd, str)
    yesflag = false
    device.transport.command(cmd) do |out|
      out.each_line do |line|
        if line.include?(str) && yesflag == false
          if device.transport.class.name.include?('Ssh')
            command = "y"
          else
            command = "y\r"
          end
          device.transport.send(command)
          yesflag = true
        end
      end
    end
  end

end
