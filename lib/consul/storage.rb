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
        config.options = { ssl: { version: :TLSv1_2 }, request: { timeout: 2 } }
      end
    end

    def self.get(option)
      instance.get(option)
    rescue Diplomat::KeyNotFound
      nil
    end

    def get(option)
      options.fetch(STORAGE_NAME.to_s, {})[option]
    end

    def options
      return { '' => {} } if test_environment?

      raise_attribute_error('CONSUL_URL') if ENV['CONSUL_URL'].to_s.empty?
      raise_attribute_error('CONSUL_NAMESPACE') if STORAGE_NAME.to_s.empty?

      Consul::StorageEntry.get do
        Diplomat::Kv.get(STORAGE_NAME, recurse: true, convert_to_hash: true)
      end
    end

    private

    def raise_attribute_error(name)
      raise ConfigurationError, "#{name} env variable is blank"
    end

    def test_environment?
      defined?(Rails) && (Rails.env.test? || Rails.env.development?)
    end
  end
end
