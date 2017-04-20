# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'random_word/version'

Gem::Specification.new do |spec|
  spec.name          = 'random-word'
  spec.version       = RandomWord::VERSION
  spec.authors       = ['Peter Williams', 'Todd Thomas']
  spec.email         = ['pezra@barelyenough.org', 'todd.thomas@openlogic.com']

  spec.summary       = %q{Pick random words for factory data}
  spec.description   = %q{A random word generator intended for use in test data factories.  This library uses a large list (the wordnet corpus) of english words and provides an enumerator interface to that corpus that will return the words in a random order without repeats.}
  spec.homepage      = 'https://github.com/openlogic/random-word'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'machinist', '~>2.0'
end
