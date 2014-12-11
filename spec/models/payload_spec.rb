require 'fast_spec_helper'
require "attr_extras"
require 'app/models/payload'

describe Payload do
  describe '#data' do
    it 'returns data' do
      data = {one: 1}
      payload = Payload.new(data)

      expect(payload.data).to eq data
    end
  end

  describe "#merge_request_id" do
    it "returns the merge request id" do
      data = {"object_attributes" => {"id" => 2}}
      payload = Payload.new(data)

      expect(payload.merge_request_id).to eq 2
    end
  end
end
