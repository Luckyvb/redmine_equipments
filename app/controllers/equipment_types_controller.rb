class EquipmentTypesController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :find_equipment_type, :except => [:new, :create, :index]

  #before_action :authorize

  def index
    sort_init [['ancestry', 'asc'], ['name', 'asc']]
    sort_update 'parent' => 'ancestry', 'name' => "#{EquipmentType.table_name}.name", 'number_template' => "#{EquipmentType.table_name}.number_template", 'ancestry' => "concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))"

    @parent = params[:parent]

    if @parent
      @rooms = EquipmentType.accessible.where(parent_id: @parent)
    else
      @equipment_types = EquipmentType.accessible.all || []
      #@equipment_types = EquipmentType.accessible.roots_only || []
    end

    @equipment_types = @equipment_types.order(sort_clause) unless @equipment_types.nil?

    @limit = per_page_option
    @equipment_type_count = @equipment_types.count
    @equipment_type_pages = Paginator.new @equipment_type_count, @limit, params[:page]
    @offset ||= @equipment_types_pages.offset unless @equipment_types_pages.nil?

    if @equipment_type_count > 0 && !@offset.blank?
      @equipment_types = @equipment_types.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @equipment_type = EquipmentType.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @equipment_type = EquipmentType.new(parent_id: @equipment_type.parent_id, name: @equipment_type.name, number_template: @equipment_type.number_template)
    render action: 'new'
  end

  def create
    @equipment_type = EquipmentType.new()
    @equipment_type.attributes = params[:equipment_type]
    if @equipment_type.save
      flash[:notice] = t('equipment_type.action.new.success')
      redirect_back_or_default
    else
      render :action => 'new'
    end
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    @equipment_type.attributes = params[:equipment_type]
    if @equipment_type.save
      flash[:notice] = t('equipment_type.action.edit.success')
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
    @equipment_type.destroy
    flash[:notice] = t('equipment_type.action.delete.success')
    redirect_back_or_default
  end

private

  def find_equipment_type
    @equipment_type = EquipmentType.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def index_params
    params.permit('parent')
  end

  def redirect_back_or_default(default = {:controller => 'equipment_types', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
