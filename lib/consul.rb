require 'consul/version'
require 'consul/storage'
require 'consul/storage_entry'
require 'diplomat'

module Consul
  def get(option)
    Storage.get(option)
  end
  module_function :get
end
