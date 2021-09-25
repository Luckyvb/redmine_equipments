class ServiceResultTypesController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :authorize
  before_action :find_service_result_type, :except => [:new, :create, :index]
  before_action :load_lists, :except => [:create, :index, :update_floors]

  helper :attachments
  include AttachmentsHelper

  def index
    sort_init [['name', 'asc']]
    sort_update 'name' => "#{ServiceResultType.table_name}.name" #, 'ancestry' => "concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))"

    @types = ServiceResultType.accessible.all || []
    @types = @types.order(sort_clause) unless @types.nil?

    @limit = per_page_option
    @service_result_type_count = @types.count
    @types_pages = Paginator.new @types, @limit, params[:page]
    @offset ||= @types_pages.offset unless @types_pages.nil?

    if @service_result_type_count > 0 && !@offset.blank?
      @types = @types.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_result_type = ServiceResultType.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @service_result_type = ServiceResultType.new(
      equipment_type_id: @service_result_type.equipment_type_id,
      service_type_id: @service_result_type.service_type_id,
      name: @service_result_type.name,
      value_format: @service_result_type.value_format,
      description: @service_result_type.description
    )
    render action: 'new'
  end

  def create
    @service_result_type = ServiceResultType.new()
    @service_result_type.attributes = params[:service_result_type]
    if @service_result_type.save
      flash[:notice] = t('service_result_type.action.new.success')
      redirect_back_or_default
    else
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
    @service_result_type.attributes = params[:service_result_type]
    if @service_result_type.save
      flash[:notice] = t('service_result_type.action.edit.success')
      redirect_back_or_default
    else
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
    @service_result_type.destroy
    flash[:notice] = t('service_result_type.action.delete.success')
    redirect_back_or_default
  rescue => e
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'destroy'
  end

private

  def find_service_result_type
    @service_result_type = ServiceResultType.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def load_lists
    load_equipment_types()
    load_service_types()
    load_value_formats()
  end

  def load_equipment_types
    @equipment_types = EquipmentType.accessible
  end
  def load_service_types
    @service_types = ServiceType.accessible
  end
  def load_value_formats
    @value_formats = []
    ['String','Text','DropDown','Checkbox'].each { |id| @value_formats |= load_value_format(id) }
    @value_formats
  end

  def load_value_format(id)
    id.blank? ? [] : [{id: id, name: t('value_format.'+id.to_s.downcase+'.title', count: 1)}]
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    #User.current.allowed_to?(:global_view_catalogs, nil, :global => true) || User.current.allowed_to?(:global_edit_catalogs, nil, :global => global)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'service_result_types', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
