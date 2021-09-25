class ServiceResultsController < ApplicationController
  unloadable

  before_action :find_project, :authorize
  before_action :find_service_result, :except => [:new, :create, :index]
  before_action :find_service, :only => [:new, :create, :copy, :edit, :update]
  before_action :load_lists, :except => [:create, :index, :update_floors]

  helper :sort
  include SortHelper
  helper :attachments
  include AttachmentsHelper

  def index
    sort_init 'service_id', 'asc'
    sort_update 'service_id' => "#{Service.table_name}.name", 'service_result_type_id' => "#{ServiceResultType.table_name}.name", 'date' => "#{ServiceResult.table_name}.date"

    sid = params[:oid]
    if oid
      @service_results = SserviceResult.accessible.where(service_id: sid)
    else
      @service_results = ServiceResult.accessible.all
    end

    @service_results = @service_results.includes(:service).includes(:service_result_type).order(sort_clause) unless @service_results.nil?

    @limit = per_page_option
    @service_results_count = @service_results.count
    @service_results_pages = Paginator.new @service_results_count, @limit, params[:page]
    @offset ||= @service_results_pages.offset unless @service_results_pages.nil?

    if @service_results_count > 0 && !@offset.blank?
      @service_results = @service_results.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_result = ServiceResult.new
    @service_result.date = Date.today
    @service_result.responsible_id = User.current.id
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_result = ServiceResult.new(
      service_id: @service_result.service_id,
      service_result_type_id: @service_result.service_result_type_id,
      responsible_id: @service_result.responsible_id,
      date: @service_result.date,
      value: @service_result.value,
      description: @service_result.description
    )
    render action: 'new'
  end

  def create
    @service_result = ServiceResult.new()
    @service_result.attributes = params[:service_result]
    @service_result.responsible_id = User.current.id if @service_result.responsible_id.blank?
    @service_result.date = Date.today if @service_result.date.blank?
    if @service_result.save
      attach(@service_result, params[:attachments])
      flash[:notice] = t('service_result.action.new.success')
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
    params[:service_result][:project_id] = @project[:id]
    @service_result.attributes = params[:service_result]
    @service_result.responsible_id = User.current.id if @service_result.responsible_id.blank?
    @service_result.date = Date.today if @service_result.date.blank?
    if @service_result.save
      attach(@service_result, params[:attachments])
      flash[:notice] = t('service_result.action.edit.success')
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
    @service_result.destroy
    flash[:notice] = t('service_result.action.delete.success')
    redirect_back_or_default
  end

private

  def find_service_result
    @service_result = ServiceResult.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_service
    @service = params[:service].blank? ? nil : Service.accessible.find(params[:service])
  end

  def find_project
    @project = nil
    if params[:project_id].blank?
      @project = @service_result.blank? || @service_result.service.blank? ? nil : @service_result.service.project
    else
      @project = Project.find(params[:project_id])
    end
  end

  def load_lists
    load_services()
    load_service_result_types()
    load_users()
  end

  def load_services
    @services = params[:service].blank? ? Service.accessible : [Service.find(params[:service])]
  end
  def load_service_result_types
    @service_result_types = ServiceResultType.accessible
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

  def redirect_back_or_default(default = {:controller => 'service_results', :action => 'index', :project_id => @project.project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
