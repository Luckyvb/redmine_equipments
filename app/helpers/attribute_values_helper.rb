module AttributeValuesHelper

  def attributable_options_for_select(selected = nil, disabled = nil)
  end

  def path_back_or_default
    session[:return_to] || {:controller => 'attribute_values', :action => 'index', :project_id => @service.project[:identifier]}
  end

end
