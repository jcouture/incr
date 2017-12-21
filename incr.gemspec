
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'incr/version'

Gem::Specification.new do |spec|
  spec.name = 'incr'
  spec.version = Incr::VERSION
  spec.authors = ['Jean-Philippe Couture']
  spec.email = ['jcouture@gmail.com']

  spec.summary = ''
  spec.homepage = 'https://github.com/jcouture/incr'
  spec.license = 'MIT'

  spec.bindir = 'bin'
  spec.executables << 'incr'
  spec.require_paths << 'lib'
end
