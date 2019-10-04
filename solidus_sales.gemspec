# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "solidus_sales"
  spec.version       = "0.0.8"
  spec.authors       = ["Noel"]
  spec.email         = ["noel@2bedigital.com"]

  spec.summary       = "Solidus Sales for show promotions in products"
  spec.description   = "Solidus Sales for show promotions in products"

  spec.require_path = 'lib'
  spec.requirements << 'none'

  solidus_version= '~> 2.1'
  spec.add_dependency 'solidus_core', solidus_version
  spec.add_dependency 'solidus_frontend', solidus_version

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
