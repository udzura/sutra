require "zendesk_api"
require "toml"
require "logger"

module Sutra
  class API
    def initialize(local_conf)
      @client = ZendeskAPI::Client.new do |config|
        config.url = local_conf.url
        config.username = local_conf.username
        config.token = local_conf.token

        if local_conf.log_file
          config.logger = Logger.new(local_conf.log_file)
        else
          config.logger = Logger.new(STDOUT)
        end
      end
    end
    attr_reader :client

    class << self
      def current
        @current ||= API.new(local_config)
      end

      def local_config
        v = TOML.load_file(ENV['SUTRA_CONFIG_PATH'] || "#{ENV['HOME']}/.sutra/config.toml")
        if nestv = v["sutra"] || v["zendesk"]
          Hashie::Mash.new(nestv)
        else
          Hashie::Mash.new(v)
        end
      end
    end
  end
end
