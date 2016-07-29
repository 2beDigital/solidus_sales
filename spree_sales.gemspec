# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "spree_sales"
  spec.version       = "0.1.0"
  spec.authors       = ["Noel"]
  spec.email         = ["noel@2bedigital.com"]

  spec.summary       = "Spree Sales for show promotions in products"
  spec.description   = "Spree Sales for show promotions in products"

  spec.require_path = 'lib'
  spec.requirements << 'none'

  spec.add_dependency 'rails', '4.1.11'

  spec.add_dependency 'spree_core', '~> 2.4'
  spec.add_dependency 'spree_frontend', '~> 2.4'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
