require_relative 'lib/webinar_ru/version'

Gem::Specification.new do |spec|
  spec.name          = "webinar_ru"
  spec.version       = WebinarRu::VERSION
  spec.authors       = ["Alexander Shvaykin"]
  spec.email         = ["skiline.alex@gmail.com"]

  spec.summary       = "webinar.ru API wrapper"
  spec.description   = "Ruby wrapper for API v3"
  spec.homepage      = "https://teachbase.ru"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/teachbase/webinar_ru"
  spec.metadata["changelog_uri"] = "http://github.com/teachbase/webinar_ru/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "evil-client"
  spec.add_dependency "tzinfo"
  spec.add_dependency "rate_throttle_client"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "webmock"
end
