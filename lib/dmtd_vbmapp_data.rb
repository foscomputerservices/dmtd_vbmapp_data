# External deps
require 'psych'
require 'json'
require 'hashie'

# Our classes
require 'dmtd_vbmapp_data/client'

require 'dmtd_vbmapp_data/guide'
require 'dmtd_vbmapp_data/guide_chapter'
require 'dmtd_vbmapp_data/guide_chapter_section'
require 'dmtd_vbmapp_data/guide_section_sub_section'

require 'dmtd_vbmapp_data/vbmapp'
require 'dmtd_vbmapp_data/vbmapp_area'
require 'dmtd_vbmapp_data/vbmapp_area_group'
require 'dmtd_vbmapp_data/vbmapp_area_question'
require 'dmtd_vbmapp_data/vbmapp_area_response'

require 'dmtd_vbmapp_data/version'

module DmtdVbmappData

  @config = {
      server_url: 'http://data-sandbox.vbmappapp.com',
      auth_token: '',
      organization_id: nil,
      document_type: 'html'
  }

  @valid_config_keys = @config.keys

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  def self.configure_with(path_to_yaml_file)
    begin
      config = Psych::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, 'YAML configuration file contains invalid syntax. Using defaults.'); return
    end

    configure(config)
  end

  def self.config
    @config
  end

end
