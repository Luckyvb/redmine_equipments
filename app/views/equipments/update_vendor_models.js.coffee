items="<%= escape_javascript(render(:partial => "vendor_models/vendor_model_options", :locals => {:vendors => @vendors, :equipment_type => @equipment_type}) ||
           "<option value='' selected='selected'>#{t('data.empty.message')}<option>".html_safe) %>"
$("#equipment_vendor_model_id").empty().append(items).prop("disabled", <%= @vendors.blank? %>).trigger('change')
