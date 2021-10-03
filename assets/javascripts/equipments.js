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
        templateSelection: select2ForrmatWithImage,
        templateResult: select2ForrmatWithImage
      });
    }
  });
};

function select2ForrmatWithImage(data){
  let $element, $wrapper;
  if (!data.element) {
    return data.text;
  }
  $element = $(data.element);
  var optimage = $element.attr('data-image');
  if(optimage && optimage !== "") {
    $wrapper = $('<span><img src="' + optimage + '" style="max-width:16px;max-height:16px" />&nbsp;' + data.text + '</span>' );
  } else{
    $wrapper = $('<span></span>');
    $wrapper.text(data.text);
  }
  $wrapper.addClass($element[0].className);
  return $wrapper;
}

getCascadingParentValues = function(data, parentId) {
  let parent = $(parentId)
  data[parent.prop('variableName')] = $(parentId+" option:selected").val();
  let pId = parent.prop('parentId');
  if(pId) {
    getCascadingParentValues(data, pId);
  }
}

function expand_detail(btn, level, max=1){
  let el = $(btn).parent().parent();
  for(let i = 0; i < max; i++) {
    el = el.next("tr");
    if(i === level)
      el.slideToggle();
    else
      el.slideUp();
  }
}
