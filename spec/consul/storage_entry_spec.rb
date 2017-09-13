require 'spec_helper'

describe Consul::StorageEntry do
  before { Singleton.__init__(Consul::StorageEntry) }

  describe '.get' do
    context 'correct retrieval' do
      it 'returns correct result within own ttl' do
        result = ->(arg) { Consul::StorageEntry.get(ttl: 2, &arg) }

        expect(result.call(proc { 5 })).to eq(5)
        sleep(1)
        expect(result.call(proc { 6 })).to eq(5)
        sleep(1)
        expect(result.call(proc { 6 })).to eq(6)
      end

      it 'in case of error, returns previous result' do
        result = ->(arg) { Consul::StorageEntry.get(ttl: 2, &arg) }

        expect(result.call(proc { 1 })).to eq(1)
        expect(result.call(proc { raise StandardError.new(message: 'oops') })).to eq(1)
      end

      it 'in case of error on initial call' do
        result = ->(arg) { Consul::StorageEntry.get(ttl: 2, &arg) }

        expect(result.call(proc { raise StandardError.new(message: 'oops') })).to eq({})
      end
    end
  end
end
