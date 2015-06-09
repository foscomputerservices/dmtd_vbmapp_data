# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dmtd_vbmapp_data/version'

Gem::Specification.new do |spec|
  spec.name          = 'dmtd_vbmapp_data'
  spec.version       = DmtdVbmappData::VERSION
  spec.authors       = ['David Hunt']
  spec.email         = ['support@vbmappapp.com']

  spec.summary       = %q{Ruby gem to simplify access to DMTD's VB-MAPP REST service}
  spec.description   = %q{This gem provides a simplified Ruby API for DMTD customers accessing the vbmappapp.com REST service.}
  spec.homepage      = 'https://github.com/foscomputerservices/dmtd_vbmapp_data'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'psych', '~> 2.0'
  spec.add_dependency 'json', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.2'
end
