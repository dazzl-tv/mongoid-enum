# frozen_string_literal: true

require 'spec_helper'
require 'mongoid7/enum/configuration'

class User
  include Mongoid::Document
  include Mongoid7::Enum

  enum :status, %i[awaiting_approval approved banned]
  enum :roles, %i[author editor admin], multiple: true, default: [], required: false
end

# rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
describe Mongoid7::Enum do
  let(:klass) { User }
  let(:instance) { User.new }
  let(:alias_name) { :status }
  let(:field_name) { :"_#{alias_name}" }
  let(:values) { %i[awaiting_approval approved banned] }
  let(:multiple_field_name) { :_roles }

  describe 'field' do
    it 'is defined' do
      expect(klass).to have_field(field_name)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'uses prefix defined in configuration' do
      old_field_name_prefix = described_class.configuration.field_name_prefix
      described_class.configure do |config|
        config.field_name_prefix = '___'
      end

      UserWithoutPrefix = Class.new do
        include Mongoid::Document
        include Mongoid7::Enum

        enum :status, %i[awaiting_approval approved banned]
      end

      expect(UserWithoutPrefix).to have_field '___status'
      described_class.configure do |config|
        config.field_name_prefix = old_field_name_prefix
      end
    end
    # rubocop:enable RSpec/ExampleLength

    it 'is aliased' do
      expect(instance).to respond_to alias_name
    end

    it 'is :aliased=' do
      expect(instance).to respond_to :"#{alias_name}="
    end

    it 'is :aliased' do
      expect(instance).to respond_to :"#{alias_name}"
    end

    describe 'type' do
      context 'when multiple' do
        it 'is an array' do
          expect(klass).to have_field(multiple_field_name).of_type(Array)
        end

        it 'validates using a custom validator' do
          expect(klass).to custom_validate(multiple_field_name).with_validator(described_class::Validators::MultipleValidator)
        end
      end

      context 'when not multiple' do
        it 'is a symbol' do
          expect(klass).to have_field(field_name).of_type(Symbol)
        end

        it 'validates inclusion in values' do
          expect(klass).to validate_inclusion_of(field_name).to_allow(values)
        end
      end
    end
  end

  describe "'required' option" do
    context 'when true' do
      let(:instance) { User.new status: nil }

      it 'is not valid with nil value' do
        expect(instance).not_to be_valid
      end
    end

    context 'when false' do
      let(:instance) { User.new roles: nil }

      it 'is valid with nil value' do
        expect(instance).to be_valid
      end
    end
  end

  describe 'constant' do
    it 'is set to the values' do
      expect(klass::STATUS).to eq values
    end
  end

  describe 'accessors' do
    context 'when singular' do
      describe 'setter' do
        it 'accepts strings' do
          instance.status = 'banned'
          expect(instance.status).to eq :banned
        end

        it 'accepts symbols' do
          instance.status = :banned
          expect(instance.status).to eq :banned
        end
      end

      describe '{{value}}!' do
        it 'sets the value' do
          instance.save
          instance.banned!
          expect(instance.status).to eq :banned
        end
      end

      describe '{{value}}?' do
        context 'when {{enum}} == {{value}}' do
          it 'returns true' do
            instance.save
            instance.banned!
            expect(instance.banned?).to eq true
          end
        end

        context 'when {{enum}} != {{value}}' do
          it 'returns false' do
            instance.save
            instance.banned!
            expect(instance.approved?).to eq false
          end
        end
      end
    end

    context 'when multiple' do
      describe 'setter' do
        it 'accepts strings' do
          instance.roles = 'author'
          expect(instance.roles).to eq [:author]
        end

        it 'accepts symbols' do
          instance.roles = :author
          expect(instance.roles).to eq [:author]
        end

        it 'accepts arrays of strings' do
          instance.roles = %w[author editor]
          instance.save
          puts instance.errors.full_messages
          instance.reload
          expect(instance.roles).to include(:author, :editor)
        end

        it 'accepts arrays of symbols' do
          instance.roles = %i[author editor]

          expect(instance.roles).to include(:author, :editor)
        end
      end

      describe '{{value}}!' do
        context 'when field is nil' do
          it 'creates an array containing the value' do
            instance.roles = nil
            instance.save
            instance.author!
            expect(instance.roles).to eq [:author]
          end
        end

        context 'when field is not nil' do
          it 'appends the value' do
            instance.save
            instance.author!
            instance.editor!
            expect(instance.roles).to eq %i[author editor]
          end
        end
      end

      describe '{{value}}?' do
        context 'when {{enum}} contains {{value}}' do
          before do
            instance.save
            instance.author!
            instance.editor!
          end

          it 'editor? returns true' do
            expect(instance.editor?).to be true
          end

          it 'author? returns true' do
            expect(instance.author?).to be true
          end
        end

        context 'when {{enum}} does not contain {{value}}' do
          it 'returns false' do
            instance.save
            expect(instance.author?).to be false
          end
        end
      end
    end
  end

  describe 'scopes' do
    context 'when singular' do
      it 'returns the corresponding documents' do
        instance.save
        instance.banned!
        expect(User.banned.to_a).to eq [instance]
      end
    end

    context 'when multiple' do
      context 'with only one document' do
        it 'returns that document' do
          instance.save
          instance.author!
          instance.editor!
          expect(User.author.to_a).to eq [instance]
        end
      end

      context 'with more than one document' do
        before do
          instance.save
          instance.author!
          instance.editor!
        end

        it 'returns all author documents with those values' do
          instance2 = klass.create
          instance2.author!

          expect(User.author.to_a).to eq [instance, instance2]
        end

        it 'returns all editor documents with those values' do
          expect(User.editor.to_a).to eq [instance]
        end
      end
    end
  end

  describe 'default values' do
    context 'when not specified' do
      it 'uses the first value' do
        instance.save
        expect(instance.status).to eq values.first
      end
    end

    context 'when specified' do
      it 'uses the specified value' do
        instance.save
        expect(instance.roles).to eq []
      end
    end
  end

  describe '.configuration' do
    it 'returns Configuration object' do
      expect(described_class.configuration)
        .to be_instance_of described_class::Configuration
    end

    it 'returns same object when called multiple times' do
      expect(described_class.configuration).to be described_class.configuration
    end
  end

  describe '.configure' do
    it 'yields configuration if block is given' do
      expect { |b| described_class.configure(&b) }
        .to yield_with_args described_class.configuration
    end
  end
end
# rubocop:enable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
