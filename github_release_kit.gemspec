# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_release_kit/version'

Gem::Specification.new do |spec|
  spec.name          = "github_release_kit"
  spec.version       = GithubReleaseKit::VERSION
  spec.authors       = ["Keisuke Ogaki"]
  spec.email         = ["keisuke_ogaki@dwango.co.jp"]

  spec.summary       = "Release binaries to github"
  spec.description   = "Release binaries to github"
  spec.homepage      = "https://github.com/opentoonz/github_release_kit"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "mime-types"
  spec.add_dependency "octokit"
  spec.add_dependency "retriable"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
