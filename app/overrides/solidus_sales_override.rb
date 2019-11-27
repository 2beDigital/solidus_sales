Deface::Override.new(virtual_path: 'spree/shared/_products',
					 name: 'replace_cost_price_products_shared',
					 insert_before:  'span.price',
					 text: '<%= display_cost_price(product) %>')

Deface::Override.new(virtual_path: 'spree/products/_cart_form',
					 name: 'replace_cost_price_products_cart_form',
					 insert_before: 'span.price',
					 text: '<%= display_cost_price(@product) %>')

Deface::Override.new(virtual_path: 'spree/shared/_products',
					 name: 'insert_span_sales_on_products',
					 insert_after: 'span.price',
					 text: '<% discount = percentage(product,product.id) %><% if discount.first > 0 && discount.second != "Spree::Calculator::FlatRate" && product.promotionable && product.price > 0 %>
					 <span class="sales">-<%= discount.first %>%</span>
					 <% elsif discount.first > 0 && discount.second == "Spree::Calculator::FlatRate" && product.promotionable && product.price > 0 %>
					 <span class="sales">-<%= Spree::Money.parse_to_money(discount.first , current_pricing_options.currency).format %></span>
					 <% end %>')

Deface::Override.new(virtual_path: 'spree/products/_cart_form',
					 name: 'insert_span_sales_on_cart_form',
					 insert_after: 'span.price',
					 text: '<% discount = percentage(@product,@product.id)%><% if discount.first > 0 && discount.second != "Spree::Calculator::FlatRate" && @product.promotionable && @product.price > 0 %>
					 <span class="sales">-<%= discount.first %>%</span>
					 <% elsif discount.first > 0 && discount.second == "Spree::Calculator::FlatRate" && @product.promotionable && @product.price > 0  %>
					 <span class="sales">-<%= Spree::Money.parse_to_money(discount.first , current_pricing_options.currency).format %></span>
					 <% end %>')