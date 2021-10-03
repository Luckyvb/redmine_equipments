class VendorModelsController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :authorize
  before_action :find_vendor_model, :except => [:new, :create, :index]
  before_action :load_lists, :only => [:new, :edit, :copy]

  def index
    sort_init 'name', 'asc'
    sort_update 'equipment_type' => "#{EquipmentType.table_name}.ancestry, #{EquipmentType.table_name}.name", 'vendor' => "#{Vendor.table_name}.name", 'name' => "#{VendorModel.table_name}.name", 'pn' => "#{VendorModel.table_name}.pn"

    vid = params[:vid]
    v = params[:v]
    etid = params[:etid]
    et = params[:type] || params[:et]

    #sql_join = "LEFT JOIN equipment_types ON equipment_type.id=vendors.equipment_type_id"
    @vendor_models = VendorModel.accessible.includes(:vendor, :equipment_type)
    if vid
      @vendor_models = @vendor_models.where(vendor_id: vid) || []
    else
      if v
        @vendor_models = @vendor_models.where('vendors.name': v) || []
      end
    end
    if etid
      @vendor_models = @vendor_models.where(equipment_type_id: etid) || []
    else
      if et
        @vendor_models = @vendor_models.where('equipment_types.name': et) || []
      end
    end

    @vendor_models = @vendor_models.reorder(sort_clause) unless @vendor_models.nil?

    Rails.logger.warn @vendor_models.to_sql

    @limit = per_page_option
    @vm_count = @vendor_models.count
    @vm_pages = Paginator.new @vm_count, @limit, params[:page]
    @offset ||= @vm_pages.offset unless @vm_pages.nil?

    if @vm_count > 0 && !@offset.blank?
      @vendor_models = @vendor_models.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = session[:return_to] || request.env["HTTP_REFERER"]
    @vendor_model = VendorModel.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    vm = @vendor_model
    @vendor_model = VendorModel.new(equipment_type_id: vm.equipment_type_id, vendor_id: vm.vendor_id, name: vm.name, pn: vm.pn, site: vm.site)
    render action: 'new'
  end

  def create
    @vendor_model = VendorModel.new()
    @vendor_model.attributes = params[:vendor_model]
    if @vendor_model.save
      flash[:notice] = t('vendor_model.action.new.success')
      redirect_back_or_default
    else
      load_lists
      render :action => 'new'
    end
  rescue => e
    if @vendor_model.blank?
      @vendor_model = VendorModel.new()
    end
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    @vendor_model.attributes = params[:vendor_model]
    if @vendor_model.save
      flash[:notice] = t('vendor_model.action.edit.success')
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
    @vendor_model.destroy
    flash[:notice] = t('vendor_model.action.delete.success')
    redirect_back_or_default
  rescue => e
    load_lists
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

private

  def find_vendor_model
    @vendor_model = VendorModel.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def load_lists
    load_equipment_types
    load_vendors
  end

  def load_equipment_types
    @equipment_types = EquipmentType.arrange_serializable(:order => :name)
  end

  def load_vendors
    @vendors = (params[:vendor].blank? ? Vendor.accessible : [Vendor.find(params[:vendor])]) || []
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'vendor_models', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
