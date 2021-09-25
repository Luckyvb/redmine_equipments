class ProjectOrganizationsController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :find_project_organization, :except => [:new, :create, :index]
  before_action :find_project#, :except => [:destroy]

  #before_action :authorize

  def index
    sort_init 'organization', 'asc'
    sort_update 'organization' => "#{Organization.table_name}.name"
    @project_organizations = ProjectOrganization.accessible.where(project_id: @project.id)

    @project_organizations = @project_organizations.includes(:organization).order(sort_clause) unless @project_organizations.nil?

    @limit = per_page_option
    @project_organization_count = @project_organizations.count
    @project_organizations_pages = Paginator.new @project_organization_count, @limit, params[:page]
    @offset ||= @project_organizations_pages.offset unless @project_organizations_pages.nil?

    if @project_organization_count > 0 && !@offset.blank?
      @project_organizations = @project_organizations.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @project_organization = ProjectOrganization.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @project_organization = ProjectOrganization.new(
      organization_id: @service_result.organization_id
    )
    render action: 'new'
  end

  def create
    @project_organization = ProjectOrganization.new()
    @project_organization.attributes = params[:project_organization]
    @project_organization.project_id = @project.id
    if @project_organization.save
      flash[:notice] = t('project_organization.action.new.success')
      redirect_back_or_default
    else
      render :action => 'new'
    end
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    @project_organization.attributes = params[:project_organization]
    @project_organization.project_id = @project.id
    if @project_organization.save
      flash[:notice] = t('project_organization.action.edit.success')
      redirect_back_or_default
    else
      render :action => 'edit'
    end
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
    @project_organization.destroy
    flash[:notice] = t('project_organization.action.delete.success')
    redirect_back_or_default
  end

private

  def find_project_organization
    @project_organization = ProjectOrganization.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  end

  def redirect_back_or_default(default = {:controller => 'project_organizations', :action => 'index', :project_id => @project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
