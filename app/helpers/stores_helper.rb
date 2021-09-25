include LocationsHelper

module StoresHelper

  def resopnsible_controller_name(store)
    store.responsible_type.downcase+'s'
  end

  def path_back_or_default
    session[:return_to] || {:controller => 'stores', :action => 'index', :project_id => @store.project[:identifier]}
  end

end
