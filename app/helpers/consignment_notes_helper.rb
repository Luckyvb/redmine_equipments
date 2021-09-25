module ConsignmentNotesHelper

  def consignment_note_tabs

    main = {:name => 'main', :action => :content, :partial => 'consignment_notes/tabs/main', :label => :tab_main}
    attachments = {:name => 'attachments', :action => :attachments, :partial => 'consignment_notes/tabs/attachments', :label => :label_attachment_plural}

    tabs = [main, attachments]

    return tabs
  end

  def path_back_or_default
    session[:return_to] || {:controller => 'consignment_notes', :action => 'index', :project_id => @consignment_note.project[:identifier]}
  end

end
