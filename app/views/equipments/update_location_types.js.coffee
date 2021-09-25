items="<%= escape_javascript(render(:partial => "location_types/options", :locals => {:location_types => @location_types || []}) || ("<option value='******' selected='selected'>"+t('data.empty.message')+"<option>").html_safe) %>"
$("#equipment_location_type").empty().append(items).prop("disabled", <%= @location_types.blank? %>).trigger('change')
