# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Enum::Configuration do
  subject(:conf) { described_class.new }

  describe 'field_name_prefix' do
    it "has '_' as default value" do
      expect(conf.field_name_prefix).to eq '_'
    end
  end
end
