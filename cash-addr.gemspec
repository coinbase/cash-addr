
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cash_addr/version'

Gem::Specification.new do |spec|
  spec.name          = 'cash-addr'
  spec.version       = CashAddr::VERSION
  spec.authors       = ['Josh Ellithorpe']
  spec.email         = ['josh.ellithorpe@coinbase.com']

  spec.summary       = 'Library to convert between base58 and CashAddr BCH addresses'
  spec.homepage      = 'https://github.com/coinbase/cash-addr'
  spec.license       = 'Apache-2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'

  spec.add_dependency 'base58', '~> 0.2.2'
end
