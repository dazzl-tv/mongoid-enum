# frozen_string_literal: true

# Define constant to gem
module Mongoid
  module Enum
    module Dazzl
      # Define version to gem
      VERSION = '1.0.0'

      # Name to gem
      GEM_NAME = 'mongoid-enum-dazzl'

      # Authors
      AUTHORS = ['VAILLANT Jeremy'].freeze

      # Emails
      EMAILS = ['jeremy@dazzl.tv'].freeze

      # Licence
      LICENSE = 'MIT'

      # Define a summary description to gem
      SUMMARY = 'Sweet enum sugar for your Mongoid documents'

      # Define a long description to gem
      DESCRIPTION = <<-DESC
    Heavily inspired by DDH's ActiveRecord::Enum, this little library is
    there to help you cut down the cruft in your models and make
    the world a happier place at the same time.
      DESC

      # Homepage to project
      HOMEPAGE = 'https://github.com/dazzl-tv/mongoid-enum'
    end
  end
end
