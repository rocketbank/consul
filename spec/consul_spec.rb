require 'spec_helper'

describe Consul do
  it 'has a version number' do
    expect(Consul::VERSION).not_to be nil
  end

  describe '.get' do
    subject { Consul.get('option') }

    it 'calls for storage' do
      expect(Consul::Storage).to receive(:get).with('option')
      subject
    end
  end
end
