$:.push File.expand_path("../lib", __FILE__)

require "action_component/version"

Gem::Specification.new do |s|
  s.name        = "action_component"
  s.version     = ActionComponent::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ["Roger Nesbitt"]
  s.email       = ["roger@seriousorange.com"]
  s.homepage    = "https://github.com/mogest/action_component"
  s.summary     = %q{React-style components for Rails}
  s.description = %q{React-style components for Rails, mixing together the controller and a DSL language for HTML views.}

  s.add_dependency "actionpack", ">= 4"
  s.add_dependency "activesupport", ">= 4"
  s.add_dependency "railties", ">= 4"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
