items="<%= escape_javascript(render(:partial => "locations/#{params[:location_type].downcase}_options", :locals => {:locations => @locations, :type => params[:location_type]}) || ("<option value='' selected='selected'>"+t('data.empty.message')+"<option>").html_safe) %>"
$("#store_location_id").empty().append(items).prop("disabled", <%= @locations.blank? %>).trigger('change')
