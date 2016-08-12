SpreeSales
=============

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spree_sales'
```

And then execute:

```ruby
bundle install
```


And finally run the install generator to automatically insert 'require spree/frontend/spree_minicart' in your asset file. If you experience a problem with loading assets from the 'vendor/assets' folder, simply copy the relevant lines into the 'app/assets' files (all.js, all.css).

```ruby
rails g spree_sales:install
```

## Instructions

Spree_sales gives us a view of the promotions that are being applied in our shop in the frontend, allocated the percentage applied to each product with its updated price and the price above cost.

They are currently implemented the following promotions:
 
Promotion for whole store (configuration):
- Without rules.
- Type of action: create-whole-adjustment
- Calculator: Flat percent. 

Promotion by categories:
- Rules: Taxons.
- Type of action: Create-line-items-adjustment
- Calculator: Percent Per Item.

## Instrucciones:

Spree_sales nos permite tener una visualización de las promociones que se están aplicando en nuestra tienda en el frontend, asignado el porcentage aplicado a cada producto con su precio actualizado y el precio de coste anterior. 

Actualmente están implementadas las siguientes promociones:
 
Promoción para toda la tienda (configuración):
- Sin reglas.
- Tipo de acción: crear un ajuste
- Calculador: Porcentaje fijo

Promoción por categorías:
- Reglas: Taxons.
- Tipo de accion: Create line items adjustment
- Calculador: Porcentaje por producto

## TODO:

Promotion products.
Promotion by users.
Promotion for visiting landing page.
Promocion first purchase

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/2bedigital/spree_sales.

