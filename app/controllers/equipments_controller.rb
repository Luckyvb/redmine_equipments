class EquipmentsController < ApplicationController
  unloadable

  helper :attachments
  include AttachmentsHelper
  helper :sort
  include SortHelper

  before_action :find_project#, :except => [:destroy]
  before_action :find_equipment, :except => [:new, :create, :index, :catalogs, :update_vendor_models, :update_owner_types, :update_owners, :update_location_types, :update_locations]
  before_action :load_lists, :only => [:new, :edit, :copy]

  #before_action :authorize

  def index
    if !params[:project_id] && !(User.current.allowed_to?(:global_view_equipments, nil, global: true) || User.current.allowed_to?(:global_edit_equipments, nil, global: true))  then return end

    sort_init [['organization_id', 'asc'],['owner_type', 'asc'],['owner_id', 'asc'],['equipment_types.name', 'asc']]
    sort_update 'id' => "#{Equipment.table_name}.id",
                'equipment_type' => "equipment_types.name", 'vendor_model' => 'vendor_model_id', 'owner' => 'owner_id', 'location' => 'location_id', 'number' => 'number', 'sn' => 'sn', 'warranty_end' => 'warranty_end'

    @p_id = @project.blank? ? 0 : @project[:id]
    @number = params[:n]
    @sn = params[:sn]
    @vendor = !params[:v].blank? ? params[:v] : params[:vendor]
    @vendor_id = !params[:v_id].blank? ? params[:v_id] : params[:vendor_id]
    @model = !params[:m].blank? ? params[:m] : params[:vm]
    @model_id = !params[:m_id].blank? ? params[:m_id] : params[:vm_id]
    @room = params[:room]
    @type = !params[:et].blank? ? params[:et] : params[:t_id]
    @type_name = !params[:t].blank? ? params[:t] : params[:type]

    @equipments = Equipment.roots.where(project_id: @p_id)
    if @type
      @equipments = @equipments.where(equipment_type: @type)
    end
    if @type_name
      @equipments = @equipments.where(equipment_types: {name: @type_name})
    end
    if @number
      @equipments = @equipments.where(number: @number)
    end
    if @sn
      @equipments = @equipments.where(sn: @sn)
    end
    if @vendor
      @equipments = @equipments.includes(vendor_model: :vendor).where(vendor_models: {vendors: {name: @vendor}})
    end
    if @vendor_id
      @equipments = @equipments.includes(:vendor_model).where(vendor_models: {vendor_models: {vendor_id: @vendor_id}})
    end
    if @model
      @equipments = @equipments.includes(:vendor_model).where(vendor_models: {name: @model})
      Rails.logger.info(@equipments.to_sql)
    end
    if @model_id
      @equipments = @equipments.where(vendor_model_id: @model_id)
    end
    if @room
      @lt = "room"
      @location = @room
    end
    if @lt
      @equipments = @equipments.where(location_type: @lt)
    end
    if @location
      @equipments = @equipments.where(location: @location)
    end

    full_sort = ['organization_id asc'] + (sort_clause.nil? ? [] : sort_clause) + ['owner_type asc', 'owner_id asc', 'equipment_types.name asc']
    @equipments = @equipments.includes(:equipment_type).select("equipments.*").order(full_sort) unless @equipments.nil?

    @limit = per_page_option
    @eq_count = @equipments.count
    @eq_pages = Paginator.new @eq_count, @limit, params[:page]
    @offset ||= @eq_pages.offset unless @eq_pages.nil?

    if @eq_count > 0 && !@offset.blank?
      @equipments = @equipments.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = session[:return_to] || request.env["HTTP_REFERER"]
    @equipment = Equipment.new()#(:project=>@project)
    @tags = @project.equipments.tag_counts
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @equipment = Equipment.new(project_id: @equipment.project_id,
                               organization_id: @equipment.organization_id,
                               equipment_type_id: @equipment.equipment_type_id,
                               vendor_model_id: @equipment.vendor_model_id,
                               owner_type: @equipment.owner_type, owner_id: @equipment.owner_id,
                               location_type: @equipment.location_type, location_id: @equipment.location_id,
                               number: @equipment.number,
                               sn: @equipment.sn,
                               warranty_end: @equipment.warranty_end
                               )
    render action: 'new'
  end

  def catalogs
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def create
    @equipment = Equipment.new(:project=>@project)#, :author_id => User.current.id)
    params[:equipment][:project_id] = @project[:id]
    @equipment.attributes = params[:equipment]
    check_fields
    @equipment.updater_id = User.current.id
    if @equipment.save
      flash[:notice] = t('equipment.action.new.success')
      redirect_back_or_default
    else
      render :action => 'new'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
    if !params[:project_id] && !(User.current.allowed_to?(:global_view_equipments, nil, global: true) || User.current.allowed_to?(:global_edit_equipments, nil, global: true))  then render_403 end
    params[:project_id] = @project[:identifier]
  end

  def update
    params[:equipment][:project_id] = @project[:id]
    @equipment.attributes = params[:equipment]
    check_fields
    @equipment.updater_id = User.current.id
    if @equipment.save
      flash[:notice] = t('equipment.action.edit.success')
      redirect_back_or_default
    else
      load_lists
      render :action => 'edit'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    load_lists
    render :action => 'edit'
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
    sort_init [['organization_id', 'asc'],['owner_type', 'asc'],['owner_id', 'asc'],['equipment_types.name', 'asc']]
    sort_update 'id' => "#{Equipment.table_name}.id",
                'equipment_type' => "equipment_types.name", 'vendor_model' => 'vendor_model_id', 'owner' => 'owner_id', 'location' => 'location_id', 'number' => 'number', 'sn' => 'sn', 'warranty_end' => 'warranty_end'

    full_sort = ['organization_id asc'] + (sort_clause.nil? ? [] : sort_clause) + ['owner_type asc', 'owner_id asc', 'equipment_types.name asc']
    @children = @equipment.children.includes(:equipment_type).order(full_sort) unless @equipment.nil? && @equipment.children.nil?

    @limit = per_page_option
    @eq_count = @children.count
    @eq_pages = Paginator.new @eq_count, @limit, params[:page]
    @offset ||= @eq_pages.offset unless @eq_pages.nil?

    if @eq_count > 0 && !@offset.blank?
      @children = @children.drop(@offset).first(@limit)
    end
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
      @equipment.destroy
      flash[:notice] = t('equipment.action.delete.success')
      redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
  end

  def tagged
    @tag = params[:id]
    @list = if params[:sort] && params[:direction]
              @project.equipments.order("#{params[:sort]} #{params[:direction]}").tagged_with(@tag)
            else
              @project.equipments.tagged_with(@tag)
            end
  end

  def update_vendor_models
    load_vendors(params[:equipment_type])
    respond_to do |format|
      format.js
    end
  end

  def update_owner_types
    parent_id = params[:parent_id]
    if !parent_id.blank?
      @owner_types=[{id: 'Equipment', name: t('equipment.title', count: 1)}]
    else
      @owner_types = load_owner_types
    end
  end

  def update_owners
    load_owners(params[:owner_type])
    respond_to do |format|
      format.js
    end
  end

  def update_location_types
    parent_id = params[:parent_id]
    owner_type = params[:owner_type]
    owner_id = params[:owner_id]
    if !parent_id.blank?
      loc_type = Equipment.find(parent_id.to_i).location_type
    else
      if !owner_type.blank? && !owner_id.blank?
        case owner_type
        when "Store", "Equipment", "Division" #"User", "Group",
          owner = owner_type.constantize.find(owner_id.to_i)
          loc_type = owner.location_type unless owner.blank?
        end
      end
    end
    if loc_type.blank?
      load_location_types
    else
      @location_types = load_location_type(loc_type)
    end
  end

  def update_locations
    parent_id = params[:parent_id]
    owner_type = params[:owner_type]
    owner_id = params[:owner_id]
    lt = params[:location_type]
    @use_simple_location = false
    if !parent_id.blank?
      @locations = find_location(lt, Equipment.find(parent_id.to_i).location_id)
      @use_simple_location = true
    else
      if !owner_type.blank? && !owner_id.blank?
        case owner_type
        when "Store", "Equipment", "Division" #"User", "Group"
          owner = owner_type.constantize.find(owner_id.to_i)
          @locations = find_location(lt, owner.location_id)
          @use_simple_location = true
        end
      else
        case lt
        when "Country", "City", "Address", "Floor", "Room"
          @locations = Country.all
        else
          load_locations(lt)
        end
      end
    end
    @locations
    respond_to do |format|
      format.js
    end
  end

private

  def check_fields
    if !@equipment.parent.blank?
      @equipment.location_type = @equipment.parent.location_type
      @equipment.location_id = @equipment.parent.location_id
      @equipment.owner_type = "Equipment"
      @equipment.owner_id = @equipment.parent_id
    else
      @equipment.location_type = @equipment.owner.location_type if @equipment.owner_type == "Store"
      @equipment.location_id = @equipment.owner.location_id if @equipment.owner_type == "Store"
    end
    if @equipment.sn == ""
      @equipment.sn = nil
    end
  end

  def find_equipment
    @equipment = params[:id].blank? && params[:id] == 'catalogs' ? Equipment.new(:project=>@project) : Equipment.accessible.find_by(project_id: @project.id, id: params[:id])
    if @equipment.blank?
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  end

  def load_lists
    load_organizations
    load_parents
    load_vendors(@equipment.blank? ? -1 : @equipment.equipment_type_id )
    load_owner_types
    ot = @equipment.blank? ? @owner_types.first[:id] : @equipment.owner_type
    load_owners(ot)
    load_location_types
    load_locations(@equipment.blank? ? @location_types.first[:id] : @equipment.location_type)
    load_addresses
    load_consignment_notes
    @tags = @project.equipments.tag_counts
  end

  def load_organizations
    @organizations = @project.blank? ? Organization.all : Organization.joins('inner join project_organizations po on eq_organizations.id=po.organization_id').where('po.project_id': @project[:id]).order(name: 'asc')
  end

  def load_users
    @users = @project.blank? ? User.all : @project.members
  end

  def load_consignment_notes
    @consignment_notes = ConsignmentNote.visible.where(project_id: @project.id)
    #@consignment_notes = ConsignmentNote.visible
  end

  def load_parents
    if !@project.blank?
      @parents = Equipment.where(project_id: @project.id).where.not(id: params[:id])
    else
      @parents = Equipment.where.not(id: params[:id])
    end
  end

  def load_vendors(et)
    @vendors = et == -1 ? Vendor.joins(:vendor_models).all : Vendor.joins(:vendor_models).where(vendor_models: {equipment_type_id: et}).distinct
  end

  def load_owner_types
    @owner_types = [
      {id: 'Division', name: t('owner_type.division', count: 1)},
      {id: 'Employee', name: t('owner_type.employee', count: 1)},
      {id: 'Store', name: t('store.title', count: 1)},
      {id: 'Equipment', name: t('equipment.title', count: 1)},
      {id: 'Group', name: t('owner_type.group', count: 1)},
      {id: 'User', name: t('owner_type.user', count: 1)}
   ]
  end

  def load_owners(ot)
    case ot
    when "Store"
      @owners = Store.where(project_id: @project[:id])
    when "Employee"
      @owners = Employee.where(project_id: @project[:id])
    when "User"
      @owners = @project.blank? ? User.where(type: ['User']) : @project.members.collect(&:user)
    when "Group"
      Rails.logger.warn @project.members
      #@owners = @project.blank? ? Group.all : @project.members.collect(&:group)
      @owners = Group.all
    when "Equipment"
      if !@project.blank?
        @owners = Equipment.where(project_id: @project[:id])#Equipment.all
      else
        @owners = Equipment.where.not(id: params[:id])
      end
    end
    if(@owners.blank?)
      @owners = []
    end
  end

  def load_location_types
    @location_types = []
    ['Country','City','Address','Floor','Room'].each { |id| @location_types |= load_location_type(id) }
    @location_types
  end

  def load_location_type(id)
    id.blank? ? [] : [{id: id, name: t(id.to_s.downcase+'.title', count: 1)}]
  end

  def load_addresses
    @addresses = Address.all
  end

  def load_locations(lt)
    case lt
    when "Country"
      @locations = Country.all
    when "City"
      @locations = City.all
    when "Address"
      @locations = Address.all
    when "Floor"
      @locations = Floor.all
    when "Room"
      #Rails.logger.warn Room.joins('inner joins room_tenants rt on rt.room_id=rooms.id', 'inner join project_organizations po on rt.organization_id=po.organization_id').where('po.project_id': @project[:id]).where('rt.end_date is nil or rt.end_date < now()').to_sql
      #@locations = @project.blank? ? Room.all : Room.joins('inner joins room_tenants rt on rt.room_id=rooms.id', 'inner join project_organizations po on rt.organization_id=po.organization_id').where('po.project_id': @project[:id]).where('rt.end_date is nil or rt.end_date < now()')
      @locations = Room.joins('inner joins room_tenants rt on rt.room_id=rooms.id', 'inner join project_organizations po on rt.organization_id=po.organization_id').where('po.project_id': @project[:id]).where('rt.end_date is nil or rt.end_date < now()')
    else
      @locations =[]
      Country.all.map { |a|
        @locations << a
      }
      City.all.map { |a|
        @locations << a
      }
      Address.all.map { |a|
        @locations << a
      }
      Floor.all.map { |f|
        @locations << f
      }
      Room.all.map { |r|
        @locations << r
      }
    end
  end

  def find_location(lt, id)
    case lt
    when "Country", "City", "Address", "Floor", "Room"
      locations = [lt.constantize.find(id)]
    #when "City"
    #  locations = [City.find(id)]
    #when "Address"
    #  locations = [Address.find(id)]
    #when "Floor"
    #  locations = [Floor.find(id)]
    #when "Room"
    #  locations = [Room.find(id)]
    else
      locations = []
    end
  end

  def index_params
    params.permit('n','et','type','t','v','v_id','vm','vm_id','room')
  end

  def redirect_back_or_default(default = {:controller => 'equipments', :action => 'index', :project_id => @equipment.project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
