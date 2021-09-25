items="<%= escape_javascript(render(:partial => @attributable_objects)) || "<option value='' selected='selected'>#{t('data.empty.message')}<option>".html_safe %>"
$("#attribute_value_attributable_id").empty().append(items).prop("disabled", <%= @attributable_objects.blank? %>).trigger('change')
