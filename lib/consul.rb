require 'consul/version'
require 'consul/storage'
require 'diplomat'

module Consul
  def get(option)
    Storage.get(option)
  end
  module_function :get
end
