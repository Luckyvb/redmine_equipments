class ServiceTypesController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :authorize
  before_action :find_service_type, :except => [:new, :create, :index]

  def index
    sort_init [['name', 'asc']]
    sort_update 'name' => "#{ServiceType.table_name}.name" #, 'ancestry' => "concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))"
    @service_types = ServiceType.accessible.all || []
    @service_types = @service_types.order(sort_clause) unless @service_types.nil?

    @limit = per_page_option
    @service_type_count = @service_types.count
    @service_type_pages = Paginator.new @service_types, @limit, params[:page]
    @offset ||= @service_types_pages.offset unless @service_types_pages.nil?

    if @service_type_count > 0 && !@offset.blank?
      @service_types = @service_types.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_type = ServiceType.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_type = ServiceType.new(name: @service_type.name)
    render action: 'new'
  end

  def create
    @service_type = ServiceType.new()
    @service_type.attributes = params[:service_type]
    if @service_type.save
      flash[:notice] = t('service_type.action.new.success')
      redirect_back_or_default
    else
      render :action => 'new'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    load_lists
    render :action => 'new'
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    @service_type.attributes = params[:service_type]
    if @service_type.save
      flash[:notice] = t('service_type.action.edit.success')
      redirect_back_or_default
    else
      render :action => 'edit'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    load_lists
    render :action => 'edit'
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_type.destroy
    flash[:notice] = t('service_type.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    load_lists
    render :action => 'index'
  end

private

  def find_service_type
    @service_type = ServiceType.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'service_types', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
