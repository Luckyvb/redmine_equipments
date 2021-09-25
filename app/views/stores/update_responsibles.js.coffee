items="<%= escape_javascript(render(:partial => "owners/options", :locals =>{:owners => @responsibles}) || ("<option value='' selected='selected'>"+t('data.empty.message')+"<option>").html_safe) %>"
$("#store_responsible_id").empty().append(items).prop("disabled", <%= @responsibles.blank? %>).trigger('change')
