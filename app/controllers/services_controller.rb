class ServicesController < ApplicationController
  unloadable

  before_action :find_project, :authorize
  before_action :find_service, :except => [:new, :create, :index]
  before_action :load_lists, :except => [:create, :index, :update_floors]

  helper :sort
  include SortHelper
  helper :attachments
  include AttachmentsHelper

  def index
    #@services = Service.accessible.all || []
    sort_init 'organization_id', 'asc'
    sort_update 'organization_id' => "#{Organization.table_name}.name", 'service_type_id' => "#{ServiceType.table_name}.name", 'start_date' => "#{Service.table_name}.start_date", 'end_date' => "#{Service.table_name}.end_date"

    oid = params[:oid]
    if oid
      @services = Sservice.accessible.where(floor_id: oid)
    else
      @services = Service.accessible.all
    end

    @services = @services.includes(:organization).order(sort_clause) unless @services.nil?

    @limit = per_page_option
    @services_count = @services.count
    @services_pages = Paginator.new @services_count, @limit, params[:page]
    @offset ||= @services_pages.offset unless @services_pages.nil?

    if @services_count > 0 && !@offset.blank?
      @services = @services.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @service = Service.new
    @service.project = @project
    @service.start_date = Date.today
    @service.send_by_id = User.current.id
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_result = Service.new(
      equipment_id: @service_result.equipment_id,
      project_id: @service_result.project_id,
      send_by_id: @service_result.send_by_id,
      start_date: @service_result.start_date,
      return_by_id: @service_result.return_by_id,
      end_date: @service_result.end_date,
      description: @service_result.description
    )
    render action: 'new'
  end

  def create
    @service = Service.new()
    @service.attributes = params[:service]
    @service.project_id = @project.id
    @service.send_by_id = User.current.id
    @service.return_by_id = nil
    @service.end_date = nil
    if @service.save
      attach(@service, params[:attachments])
      flash[:notice] = t('service.action.new.success')
      redirect_back_or_default
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
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    params[:service][:project_id] = @project[:id]
    @service.attributes = params[:service]
    @service.project_id = @project.id
    if @service.save
      attach(@service, params[:attachments])
      flash[:notice] = t('service.action.edit.success')
      redirect_back_or_default
    else
      load_lists
      render :action => 'edit'
    end
  rescue => e
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'edit'
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service.destroy
    flash[:notice] = t('service.action.delete.success')
    redirect_back_or_default
  end

private

  def find_service
    @service = Service.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  end

  def load_lists
    load_equipments()
    load_organizations()
    load_service_types()
    load_users()
  end

  def load_equipments
    @equipments = params[:equipment].blank? ? Equipment.accessible.where(project_id: @project.id) : [Equipment.find(params[:equipment])]
  end
  def load_organizations
    @organizations = Organization.all #ProjectOrganization.joins(:organization).where(project_id: @project.id).select('eq_organizations.*')
  end
  def load_service_types
    @service_types = ServiceType.accessible
  end
  def load_users
    @users = @project.blank? ? User.all : @project.members.collect(&:user)
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

  def redirect_back_or_default(default = {:controller => 'services', :action => 'index', :project_id => @service.project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
