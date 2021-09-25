items="<%= escape_javascript(render(:partial => "owner_type_options", :locals =>{:owner_types => @owner_types || []}) || ("<option value='' selected='selected'>"+t('data.empty.message')+"<option>").html_safe) %>"
$("#equipment_owner_type").empty().append(items).prop("disabled", <%= @owner_types.blank? %>).trigger('change')
