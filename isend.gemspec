Gem::Specification.new do |spec|
  spec.name          = "isend"
  spec.version       = "1.0.0"
  spec.authors       = ["isend.ai"]
  spec.email         = ["support@isend.ai"]

  spec.summary       = "Ruby SDK for isend.ai - Send emails easily using email connectors like SES, SendGrid, and more"
  spec.description   = "A simple Ruby SDK for sending emails through isend.ai using various email connectors like AWS SES, SendGrid, Mailgun, and more."
  spec.homepage      = "https://github.com/isend-ai/ruby-sdk"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = Dir.glob("{lib,examples}/**/*") + %w[README.md LICENSE CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "json", "~> 2.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.50"
end 