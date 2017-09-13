require 'singleton'
module Consul
  class StorageEntry
    DEFAULT_TTL = 60 * 60 # 1 hour
    include Singleton
    class ErrorResult; end

    def initialize
      @mutex = Mutex.new
      @value = nil
      @added_at = 0
    end

    def self.get(ttl: DEFAULT_TTL, &block)
      instance.get(ttl: ttl, &block)
    end

    def get(ttl:, &block)
      return @value if !@value.nil? && @added_at + ttl > Time.now.to_i
      @mutex.synchronize do
        @added_at = Time.now.to_i
        @value = value_or_default(&block)
      end
      @value
    end

    def value_or_default
      value = begin
        yield if block_given?
      rescue StandardError
        ErrorResult.new
      end

      if value.is_a?(ErrorResult)
        return @value.nil? ? {} : @value
      end
      value
    end
  end
end
