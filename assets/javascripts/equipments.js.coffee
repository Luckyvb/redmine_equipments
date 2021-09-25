#$ ->
#  $(document).on 'change', '#room_address_id', (evt) ->
#    $.ajax 'update_floors',
#      type: 'GET'
#      dataType: 'script'
#      data: {
#        address_id: $("#room_address_id option:selected").val()
#      }
#      error: (jqXHR, textStatus, errorThrown) ->
#        console.log("AJAX Error: #{textStatus}")
#      success: (data, textStatus, jqXHR) ->
#        console.log("Dynamic country select OK!")
#
#initSelects = (ddl) ->
#  ddl.forEach (el) ->
#    if typeof $(el.id).select2 != 'undefined'
#      $(el.id).select2
#        allowClear: el.allowClear
#        templateResult: (data) ->
#          if !data.element
#            return data.text
#          $element = $(data.element)
#          $wrapper = $('<span></span>')
#          $wrapper.addClass $element[0].className
#          $wrapper.text data.text
#          $wrapper
#      $(el.id).prop 'disabled', el.disabled
#    return
#  return
