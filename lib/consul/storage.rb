require 'singleton'

module Consul
  class Storage
    STORAGE_NAME = ENV.fetch('CONSUL_NAMESPACE', 'default')
    include Singleton
    attr_reader :options

    def initialize
      Diplomat.configure do |config|
        config.url = ENV['CONSUL_URL'] || ''
        config.options = { ssl: { version: :TLSv1_2 } }
      end
      @options = Diplomat::Kv.get(STORAGE_NAME, recurse: true,
                                                convert_to_hash: true)
    end

    def self.get(option)
      instance.get(option)
    rescue Diplomat::KeyNotFound
      nil
    end

    def get(option)
      options[STORAGE_NAME][option]
    end
  end
end
