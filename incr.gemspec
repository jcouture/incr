
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

  spec.bindir = 'bin'
  spec.executables << 'incr'
  spec.require_paths << 'lib'

  spec.add_runtime_dependency('gli', '2.17.1')
  spec.add_runtime_dependency('sem_version', '2.0.1')
  spec.add_runtime_dependency('rugged', '0.26.0')
end
