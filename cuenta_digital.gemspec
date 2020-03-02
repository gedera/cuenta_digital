lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cuenta_digital/version"

Gem::Specification.new do |spec|
  spec.name          = "cuenta_digital"
  spec.version       = CuentaDigital::VERSION
  spec.authors       = ["ga6ix"]
  spec.email         = ["gab.edera@gmail.com"]

  spec.summary       = %q{Cuenta Digital API.}
  spec.description   = %q{Cuenta Digital API gem.}
  spec.homepage      = "https://github.com/gedera/cuenta_digital"
  spec.license       = "MIT"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.10.9'
  spec.add_dependency 'nori', '~> 2.6.0'

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0.1"
  # spec.add_development_dependency "minitest", "~> 5.0"
end
