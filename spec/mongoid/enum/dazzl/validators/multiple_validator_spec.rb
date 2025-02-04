# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

describe Mongoid::Enum::Dazzl::Validators::MultipleValidator do
  subject { described_class }

  let(:values) { %i[lorem ipsum dolor sit] }
  let(:attribute) { :word }
  let(:record) { OpenStruct.new(:errors => { attribute => [] }, attribute => values.first) }
  let(:allow_nil) { false }
  let(:validator) { subject.new(attributes: attribute, in: values, allow_nil: allow_nil) }

  describe '.validate_each' do
    context 'when allow_nil: true' do
      let(:allow_nil) { true }

      context 'with value is nil' do
        before { validator.validate_each(record, attribute, nil) }

        it 'validates' do
          expect(record.errors[attribute].empty?).to be true
        end
      end

      context 'with value is []' do
        before { validator.validate_each(record, attribute, []) }

        it 'validates' do
          expect(record.errors[attribute].empty?).to be true
        end
      end
    end

    context 'when allow_nil: false' do
      context 'with value is nil' do
        before { validator.validate_each(record, attribute, nil) }

        it "won't validate (true)" do
          expect(record.errors[attribute].any?).to be true
        end

        it "won't validate (equal)" do
          expect(record.errors[attribute]).to eq ["is not in #{values.join ', '}"]
        end
      end

      context 'with value is []' do
        before { validator.validate_each(record, attribute, []) }

        it "won't validate (true)" do
          expect(record.errors[attribute].any?).to be true
        end

        it "won't validate (equal)" do
          expect(record.errors[attribute]).to eq ["is not in #{values.join ', '}"]
        end
      end
    end

    context 'when value is included' do
      let(:allow_nil) { rand(2).zero? }

      before { validator.validate_each(record, attribute, [values.sample]) }

      it 'validates' do
        expect(record.errors[attribute].empty?).to be true
      end
    end

    context 'when value is not included' do
      let(:allow_nil) { rand(2).zero? }

      before { validator.validate_each(record, attribute, [:amet]) }

      it "won't validate" do
        expect(record.errors[attribute].any?).to be true
      end
    end

    context 'when multiple values included' do
      let(:allow_nil) { rand(2).zero? }

      before { validator.validate_each(record, attribute, [values.first, values.last]) }

      it 'validates' do
        expect(record.errors[attribute].empty?).to be true
      end
    end

    context 'when one value is not included ' do
      let(:allow_nil) { rand(2).zero? }

      before { validator.validate_each(record, attribute, [values.first, values.last, :amet]) }

      it "won't validate" do
        expect(record.errors[attribute].any?).to be true
      end
    end
  end
end
