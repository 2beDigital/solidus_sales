Deface::Override.new(virtual_path: 'spree/admin/promotions/_form',
					 name: 'add_active_solidus_sales',
					 insert_bottom: 'div#general_fields div.row div.col-xs-3',
					 text: '<%= f.field_container :active_solidus_sales do %>
						        <%= f.check_box :active_solidus_sales %>
						        <%= f.label :active_solidus_sales %>
							<% end %>')