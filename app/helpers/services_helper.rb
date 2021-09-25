module ServicesHelper

  def service_tabs

    main = {:name => 'main', :action => :content, :partial => 'services/tabs/main', :label => :tab_main}
    attachments = {:name => 'attachments', :action => :attachments, :partial => 'services/tabs/attachments', :label => :label_attachment_plural}

    tabs = [main, attachments]

    return tabs
  end

  def path_back_or_default
    session[:return_to] || {:controller => 'services', :action => 'index', :project_id => @service.project[:identifier]}
  end

end
