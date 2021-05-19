# frozen_string_literal: true

SimpleCov.start do
  # Merge result
  use_merging true

  # Formatter
  formatter SimpleCov::Formatter::JSONFormatter

  # Add branch coverage measurement statistics
  enable_coverage :branch
end
