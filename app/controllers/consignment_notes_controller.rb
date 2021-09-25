class ConsignmentNotesController < ApplicationController
  unloadable

  helper :sort
  include SortHelper
  helper :attachments
  include AttachmentsHelper

  before_action :find_project, :authorize#, :except => [:destroy]
  before_action :find_consignment_note, :except => [:new, :create, :index]
  before_action :load_lists, :except => [:create, :index, :update_floors]

  def index
    sort_init [['number', 'asc']]
    sort_update 'number' => "#{ConsignmentNote.table_name}.number" #, 'ancestry' => "concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))"
    @consignment_notes = ConsignmentNote.accessible.where(project_id: @project.id).all || []
    @consignment_notes = @consignment_notes.order(sort_clause) unless @consignment_notes.nil?

    @limit = per_page_option
    @consignment_note_count = @consignment_notes.count
    @consignment_note_pages = Paginator.new @consignment_notes, @limit, params[:page]
    @offset ||= @consignment_note_pages.offset unless @consignment_note_pages.nil?

    if @consignment_note_count > 0 && !@offset.blank?
      @consignment_notes = @consignment_notes.drop(@offset).first(@limit)
    end
  end

  def new
    @consignment_note = ConsignmentNote.new
  end

  def copy
    @consignment_note = ConsignmentNote.new(organization_id: @consignment_note.organization_id,
                                            seller_id: @consignment_note.seller_id,
                                            document_type_id: @consignment_note.document_type_id,
                                            number: @consignment_note.number,
                                            date: @consignment_note.date,
                                            total: @consignment_note.total,
                                            description: @consignment_note.description)
    render action: 'new'
  end

  def create
    params[:consignment_note][:project_id] = @project[:id]
    @consignment_note = ConsignmentNote.new()
    @consignment_note.attributes = params[:consignment_note]
    if @consignment_note.save
      attachments = attach(@consignment_note, params[:attachments])
      flash[:notice] = t('consignment_note.action.new.success')
      redirect_back_or_default({:controller => 'consignment_notes', :action => 'index', :project_id => @consignment_note.project[:identifier]})
    else
      load_lists
      render :action => 'new'
    end
  rescue => e
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

  def edit
  end

  def update
    params[:consignment_note][:project_id] = @project[:id]
    @consignment_note.attributes = params[:consignment_note]
    if @consignment_note.save
      attach(@consignment_note, params[:attachments])
      flash[:notice] = t('consignment_note.action.edit.success')
      redirect_back_or_default({:controller => 'consignment_notes', :action => 'index', :project_id => @consignment_note.project[:identifier]})
    else
      load_lists
      flash[:error] = "#{t('error')}"
      render :action => 'edit'
    end
  rescue => e
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'edit'
  end

  def show
  end

  def destroy
    @consignment_note.destroy
    flash[:notice] = t('consignment_note.action.delete.success')
    #redirect_to :controller => 'consignment_notes', :action => 'index', :project_id => @consignment_note.project[:identifier]
    redirect_back_or_default({:controller => 'consignment_notes', :action => 'index', :project_id => @consignment_note.project[:identifier]})
  end

private

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_consignment_note
    @consignment_note = ConsignmentNote.accessible.where(project_id: @project.id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def load_lists
    load_organizations()
    load_sellers()
    load_document_types()
  end

  def load_organizations
    @organizations = @project.blank? ? Organization.all : Organization.joins('inner join project_organizations po on eq_organizations.id=po.organization_id').where('po.project_id': @project[:id]).order(name: 'asc')
  end

  def load_sellers
    @sellers = Organization.all #ProjectOrganization.joins(:organization).where(project_id: @project.id).select('eq_organizations.*')
  end

  def load_document_types
    @document_types = DocumentType.accessible
  end

  # Abstract attachment method to resolve how files should be attached to a model.
  # In newer versions of Redmine, the attach_files functionality was moved
  # from the application controller to the attachment model.
  def attach(target, attachments)
    if Attachment.respond_to?(:attach_files)
      Attachment.attach_files(target, attachments)
      render_attachment_warning_if_needed(target)
    else
      attach_files(target, attachments)
    end
  end

  def redirect_back_or_default(default)
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
