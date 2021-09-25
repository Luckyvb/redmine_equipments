initCascadingSelect = function(params) {
  $(params.childId).prop('parentId', params.parentId);
  $(params.parentId).prop('variableName', params.variableName);
  $(params.parentId).on('change', function(evt) {
    $(params.childId).empty().trigger('change');
    if(params.disableChild === true)
      $(params.childId).prop("disabled", true)
    let data = {};
    getCascadingParentValues(data, params.parentId);
    return $.ajax(params.methodName, {
      type: 'GET',
      dataType: 'script',
      data: data,
      error: function(jqXHR, textStatus, errorThrown) {
        return console.log(params.parentId+": AJAX Error: " + textStatus);
      },
      success: function(data, textStatus, jqXHR) {
        return console.log(params.parentId+": Dynamic select OK!");
      }
    });
  });
};

initSelects = function(ddl) {
  ddl.forEach(function(el) {
    if (typeof $(el.id).select2 !== 'undefined') {
      $(el.id).select2({
        placeholder: "",
        allowClear: el.allowClear,
        disabled: el.disabled,
        templateResult: function(data) {
          let $element, $wrapper;
          if (!data.element) {
            return data.text;
          }
          $element = $(data.element);
          $wrapper = $('<span></span>');
          $wrapper.addClass($element[0].className);
          $wrapper.text(data.text);
          return $wrapper;
        }
      });
    }
  });
};

getCascadingParentValues = function(data, parentId) {
  let parent = $(parentId)
  data[parent.prop('variableName')] = $(parentId+" option:selected").val();
  let pId = parent.prop('parentId');
  if(pId) {
    getCascadingParentValues(data, pId);
  }
}