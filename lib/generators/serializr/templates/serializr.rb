<% module_namespacing do -%>
class <%= class_name %>Serializer < <%= parent_class_name %>
  <% if attributes.present? -%>
  attributes <%= attributes.map { |a| a.name.to_sym.inspect }.join(', ') %>
  <% end %>
end
<% end -%>
