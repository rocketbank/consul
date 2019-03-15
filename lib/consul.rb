require 'consul/version'
require 'consul/storage'
require 'consul/storage_entry'
require 'diplomat'

module Consul
  Diplomat.configure do |config|
    config.url = ENV['CONSUL_URL'] || 'http://localhost'
    config.options = { ssl: { version: :TLSv1_2 }, request: { timeout: 5 } }
  end

  def get(option = nil)
    Storage.get(option)
  end
  module_function :get
end
