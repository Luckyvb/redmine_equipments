items="<%= escape_javascript(render(:partial => "owner_options", :locals =>{:owners => @owners || []}) || ("<option value='' selected='selected'>"+t('data.empty.message')+"<option>").html_safe) %>"
$("#equipment_owner_id").empty().append(items).prop("disabled", <%= @owners.blank? %>).trigger('change')
