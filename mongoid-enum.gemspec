lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/enum/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-enum'
  spec.version       = Mongoid::Enum::VERSION
  spec.authors       = ['Vaillant Jeremy']
  spec.email         = ['jeremy@dazzl.tv']

  spec.description   = "Heavily inspired by DDH's ActiveRecord::Enum, this little library is there to help you cut down the cruft in your models and make the world a happier place at the same time."
  spec.summary       = 'Sweet enum sugar for your Mongoid documents'
  spec.homepage      = 'https://github.com/dazzl-tv/mongoid-enum'
  spec.license       = 'MIT'

  # spec.files         = `git ls-files`.split($/)
  spec.files         = ['Gemfile', 'Rakefile']
  spec.files         += ['README.md']
  spec.files         += Dir['spec/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.2', '<= 2.2.16'
  spec.add_development_dependency 'faker', '~> 2.17'
  spec.add_development_dependency 'mongoid-rspec', '~> 4.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
  spec.add_development_dependency 'reek', '~> 6.0.4'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.13.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'

  spec.add_dependency 'mongoid', '~> 7.2', '>= 7.2.2'
end
