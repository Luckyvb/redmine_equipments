class RoomTenantsController < ApplicationController
  unloadable

  before_action :find_project, :authorize
  before_action :find_room_tenant, :except => [:new, :create, :index]
  before_action :find_room, :except => [:create, :index]
  before_action :load_lists, :except => [:create, :index, :update_responsibles, :update_locations]

  helper :sort
  include SortHelper

  def index
    sort_init 'room', 'asc'
    sort_update 'room' => "#{Country.table_name}.short_name, #{City.table_name}.name, #{Address.table_name}.name, #{Floor.table_name}.number, #{Room.table_name}.number", 'organization' => "#{Organization.table_name}.name", 'start_date' => "#{RoomTenant.table_name}.start_date", 'end_date' => "#{RoomTenant.table_name}.end_date"

    sql_join = "LEFT JOIN floors ON floors.id = rooms.floor_id LEFT JOIN addresses ON addresses.id = floors.address_id LEFT JOIN cities ON cities.id = addresses.city_id JOIN countries ON countries.id = cities.country_id"
    @room_tenants = RoomTenant.accessible.includes(:room).joins(:room).joins(sql_join).order(sort_clause) || []

    @limit = per_page_option
    @room_tenants_count = @room_tenants.count
    @room_tenants_pages = Paginator.new @room_tenants_count, @limit, params[:page]
    @offset ||= @room_tenants_pages.offset unless @room_tenants_pages.nil?

    if @room_tenants_count > 0 && !@offset.blank?
      @rooms = @room_tenants.drop(@offset).first(@limit)
    end
  end

  def init_pages()

  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @room_tenant = RoomTenant.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @room_tenant = RoomTenant.new(room_id: @room_tenant.room_id, organization_id: @room_tenant.organization_id, start_date: @room_tenant.start_date, end_date: @room_tenant.end_date, description: @room_tenant.description)
    render action: 'new'
  end

  def create
    @room_tenant = RoomTenant.new()
    @room_tenant.attributes = params[:room_tenant]
    if @room_tenant.save
      flash[:notice] = t('room_tenant.action.new.success')
      redirect_back_or_default
    else
      flash[:error] = "#{t('error')}:#{t('room_tenant.action.new.error')}"
      #find_room
      @room = Room.accessible.find(@room_tenant.room_id)
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
    @room_tenant.attributes = params[:room_tenant]
    if @room_tenant.save
      flash[:notice] = t('room_tenant.action.edit.success')
      redirect_back_or_default
    else
      find_room
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
    @room_tenant.destroy
    flash[:notice] = t('room_tenant.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

private

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  end

  def find_room_tenant
    @room_tenant = RoomTenant.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_room
    @room = params[:room].blank? ? nil : Room.accessible.find(params[:room])
  end

  def load_lists
    load_rooms
    load_organizations
  end

  def load_rooms
    @rooms = @room.blank? ? Room.accessible : [@room]
  end

  def load_organizations
    @organizations = @project.blank? ? Organization.all : Organization.joins('inner join project_organizations po on eq_organizations.id=po.organization_id').where('po.project_id': @project.id).order(name: 'asc')
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'room_tenants', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
