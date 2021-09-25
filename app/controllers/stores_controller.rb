class StoresController < ApplicationController
  unloadable

  before_action :find_project_by_project_id
  #before_action :find_store_project
  before_action :find_store, :except => [:new, :create, :index, :update_responsibles, :update_locations]
  before_action :load_lists, :except => [:create, :index, :update_responsibles, :update_locations]

  #before_action :authorize

  helper :sort
  include SortHelper
  

  def index
    sort_init 'name', 'asc'
    sort_update 'name' => "#{Store.table_name}.name"

    @pid = params[:pid]

    @@stores = Store.accessible
    if @pid
      @stores = Store.accessible.where(project_id: @project.id, parent_id: @pid)
    else
      @stores = Store.accessible.where(project_id: @project.id)
    end

    @stores = @stores.order(sort_clause) unless @stores.nil?

    @limit = per_page_option
    @store_count = @stores.count
    @store_pages = Paginator.new @store_count, @limit, params[:page]
    @offset ||= @stores_pages.offset unless @stores_pages.nil?

    if @store_count > 0 && !@offset.blank?
      @stores = @stores.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @store = Store.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @store = Store.new(
      organization_id: @store.organization_id,
      parent_id: @store.parent_id,
      name: @store.name,
      is_abstract: @store.is_abstract,
      location_type: @store.location_type,
      location_id: @store.location_id,
      responsible_type: @store.responsible_type,
      responsible_id: @store.responsible_id
    )
    render action: 'new'
  end

  def create
    @store = Store.new()
    @store.attributes = params[:store]
    @store.project_id = @project.id
    if @store.save
      flash[:notice] = t('store.action.new.success')
      redirect_back_or_default
    else
      flash[:error] = @store.errors.full_messages
      load_lists
      render :action => 'new'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

  def edit
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def update
    @store.attributes = params[:store]
    if @store.save
      flash[:notice] = t('store.action.edit.success')
      redirect_back_or_default
    else
      render :action => 'edit'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'edit'
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
    @store.destroy
    flash[:notice] = t('store.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

  def update_responsibles
    load_responsible(params[:responsible_type])
    respond_to do |format|
      format.js
    end
  end

  def update_locations
    lt = params[:location_type]
    @use_simple_location = false
    case lt
    when "Country", "City", "Address", "Floor", "Room"
      @locations = Country.all
    else
      load_locations(lt)
    end
    respond_to do |format|
      format.js
    end
  end

private

  def find_store
    @store = Store.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_store_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def load_lists
    load_organizations
    load_parents
    load_location_types
    load_locations(@store.blank? ? @location_types.first[:id] : @store.location_type)
    load_responsible_types
    load_responsible(@store.blank? ? @responsible_types.first[:id] : @store.responsible_type)
    load_addresses()
  end

  def load_addresses
    @addresses = Address.accessible
  end

  def load_organizations
    @organizations = @project.blank? ? Organization.all : Organization.joins('inner join project_organizations po on eq_organizations.id=po.organization_id').where('po.project_id': @project.id).order(name: 'asc')
  end

  def load_users
    @users = @project.blank? ? User.all : @project.members
  end

  def load_parents
    @parents = Store.where(project_id: @project.id).where.not(id: params[:id])
  end

  def load_responsible_types
    @responsible_types = [
      {id: 'Division', name: t('owner_type.division', count: 1)},
      {id: 'Employee', name: t('owner_type.employee', count: 1)},
      {id: 'User', name: t('owner_type.user', count: 1)},
      {id: 'Group', name: t('owner_type.group', count: 1)}
    ]
  end

  def load_responsible(r)
    case r
      when "Division"
        @responsibles = Division.where(project_id: @project[:id])
      when "Employee"
        @responsibles = Employee.where(project_id: @project[:id])
      when "User"
        @responsibles = User.where(type: ['User'])
      when "Group"
        @responsibles = Group.all
      end
  end

  def load_location_types
    @location_types = [{id: 'Country', name: t('country.title', count: 1)},{id: 'City', name: t('city.title', count: 1)},{id: 'Address', name: t('address.title', count: 1)},{id: 'Floor', name: t('floor.title', count: 1)},{id: 'Room', name: t('room.title', count: 1)}]
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
        @locations = Room.joins('inner joins room_tenants rt on rt.room_id=rooms.id', 'inner join project_organizations po on rt.organization_id=po.organization_id').where('po.project_id': @project[:id]).where('rt.end_date is nil or rt.end_date < now()')
        #@locations = Room.all
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
        Room.joins('inner joins room_tenants rt on rt.room_id=rooms.id', 'inner join project_organizations po on rt.organization_id=po.organization_id').where('po.project_id': @project[:id]).where('rt.end_date is nil or rt.end_date < now()').map { |r|
          @locations << r
        }
    end
  end

  def index_params
    params.permit('pid','n','location_type','location')
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'stores', :action => 'index', :project_id => @project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
