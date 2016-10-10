Deface::Override.new(virtual_path: 'spree/shared/_products',
					 name: 'replace_cost_price_products_shared',
					 insert_before:  'span.price',
					 text: '<%= display_cost_price(product) %>')

Deface::Override.new(virtual_path: 'spree/products/_cart_form',
					 name: 'replace_cost_price_products_cart_form',
					 replace: 'erb[loud]:contains("Spree::Money.new(@product.cost_price, { currency: current_currency }).to_html")',
					 text: '<%= display_cost_price(@product) %>')

Deface::Override.new(virtual_path: 'spree/shared/_products',
					 name: 'insert_span_sales_on_products',
					 insert_bottom: 'div.texts',
					 text: '<% if percentage(product.id) > 0 && is_promotionable?(product) && product.price > 0 %><span class="sales">-<%= percentage(product.id) %>%</span><% end %>')

Deface::Override.new(virtual_path: 'spree/products/_cart_form',
					 name: 'insert_span_sales_on_cart_form',
					 insert_after: 'span.price',
					 text: '<% if percentage(@product.id) > 0 && is_promotionable?(@product) && @product.price > 0 %><span class="sales">-<%= percentage(@product.id) %>%</span><% end %>')