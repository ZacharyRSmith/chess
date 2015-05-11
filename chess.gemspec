# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "chess"
  spec.version       = '0.1'
  spec.authors       = ["Zachary R. Smith"]
  spec.email         = ["ZacharySmith4989@gmail.com"]
  spec.summary       = %q{A command-line recreation of chess.}
  spec.description   = %q{This program is text-based. It referees moves' legality.}
  spec.homepage      = "https://github.com/ZacharyRSmith/chess"
  spec.license       = "MIT"

  spec.files         = ['lib/chess.rb']
  spec.executables   = ['bin/chess']
  spec.test_files    = ['tests/test_chess.rb']
  spec.require_paths = ["lib"]
end