$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hisui/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hisui"
  s.version     = Hisui::VERSION
  s.authors     = ["ikepon"]
  s.email       = ["tatsuyanoheya@gmail.com"]
  s.homepage    = "https://github.com/ikepon/hisui"
  s.summary     = "Access the Google Analytics Reporting API v4 On Rails"
  s.description = "Access the Google Analytics Reporting API v4 On Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.1.0"
  s.add_dependency "oauth2"
  s.add_dependency "google-api-client"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "dotenv"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "simplecov"
end
