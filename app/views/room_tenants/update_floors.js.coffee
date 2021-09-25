$("#room_floor_id").empty().append("<%= escape_javascript(render(:partial => @floors)) %>").prop("disabled", <%= @floors.blank? %>).trigger('change')
