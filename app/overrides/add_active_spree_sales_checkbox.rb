Deface::Override.new(virtual_path: 'spree/admin/promotions/_form',
					 name: 'add_active_spree_sales',
					 insert_bottom: 'div#general_fields div.alpha.four.columns',
					 text: '<%= f.field_container :active_spree_sales do %>
						        <%= f.check_box :active_spree_sales %>
						        <%= f.label :active_spree_sales %>
							<% end %>')