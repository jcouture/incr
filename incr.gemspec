
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'incr/version'

Gem::Specification.new do |spec|
  spec.name = 'incr'
  spec.version = Incr::VERSION
  spec.authors = ['Jean-Philippe Couture']
  spec.email = ['jcouture@gmail.com']

  spec.summary = 'Tasteful utility to increment the version number and create a corresponding git tag.'
  spec.homepage = 'https://github.com/jcouture/incr'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.bindir = 'bin'
  spec.executables << 'incr'
  spec.require_paths << 'lib'

  spec.required_ruby_version = '>= 3.2'

  spec.add_runtime_dependency('gli', '2.21.1')
  spec.add_runtime_dependency('sem_version', '2.0.1')
  spec.add_runtime_dependency('git', '1.19.1')

  spec.add_development_dependency('rake', '13.2.1')
  spec.add_development_dependency('rspec', '3.12.0')
  spec.add_development_dependency('rubocop', '1.63.5')
  spec.add_development_dependency('meowcop', '3.2.0')
end
