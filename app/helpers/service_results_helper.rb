include LocationsHelper

module ServiceResultsHelper

  def path_back_or_default
    session[:return_to] || {:controller => 'service_results', :action => 'index', :project_id => @store.project[:identifier]}
  end

end
