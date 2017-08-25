require 'singleton'

module Consul
  class ConfigurationError < StandardError; end
  class Storage
    STORAGE_NAME = ENV['CONSUL_NAMESPACE']
    include Singleton
    attr_reader :options

    def initialize
      Diplomat.configure do |config|
        config.url = ENV['CONSUL_URL'] || 'http://localhost'
        config.options = { ssl: { version: :TLSv1_2 } }
      end
    end

    def self.get(option)
      raise_attribute_error('CONSUL_URL') if ENV['CONSUL_URL'].to_s.empty?
      raise_attribute_error('CONSUL_NAMESPACE') if STORAGE_NAME.to_s.empty?

      instance.get(option)
    rescue Diplomat::KeyNotFound
      nil
    end

    def self.raise_attribute_error(name)
      raise ConfigurationError, "#{name} env variable is blank"
    end

    def get(option)
      options[STORAGE_NAME][option]
    end

    def options
      return { STORAGE_NAME => {} } if test_environment?
      @options ||= Diplomat::Kv.get(STORAGE_NAME, recurse: true,
                                                  convert_to_hash: true)
    end

    private

    def test_environment?
      respond_to?(Rails) && Rails.env.test?
    end
  end
end
