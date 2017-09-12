require 'singleton'
module Consul
  class StorageEntry
    DEFAULT_TTL = 60 * 60 # 1 hour
    include Singleton

    def initialize(ttl = DEFAULT_TTL)
      @ttl = ttl
      @mutex = Mutex.new
      @value = nil
      @added_at = 0
    end

    def self.get(&block)
      instance.get(block.call)
    end

    def get(value)
      return @value if !@value.nil? && @added_at + @ttl > Time.now.to_i
      @mutex.synchronize do
        @value = value
        @added_at = Time.now.to_i
      end
      @value
    end
  end
end
