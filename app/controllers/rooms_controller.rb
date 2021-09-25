class RoomsController < ApplicationController
  unloadable

  before_action :authorize

  before_action :find_room, :except => [:new, :create, :index, :update_floors]
  before_action :load_lists, :except => [:create, :index, :update_floors]

  helper :sort
  include SortHelper

  def index
    sort_init 'number', 'asc'
    sort_update 'id' => "#{Room.table_name}.id", 'floor' => "#{Country.table_name}.short_name, #{City.table_name}.name, #{Address.table_name}.name, #{Floor.table_name}.number", 'number' => "#{Room.table_name}.number", 'name' => "#{Room.table_name}.name"

    @fid = params[:fid]

    if @fid
      @rooms = Room.accessible.where(floor_id: @fid)
    else
      @rooms = Room.accessible.all
    end

    sql_join = "LEFT JOIN addresses ON addresses.id = floors.address_id LEFT JOIN cities ON cities.id = addresses.city_id JOIN countries ON countries.id = cities.country_id"
    @rooms = @rooms.includes(:floor).joins(:floor).joins(sql_join).order(sort_clause) unless @rooms.nil?

    #Rails.logger.warn @rooms.to_sql

    @limit = per_page_option
    @rooms_count = @rooms.count
    @rooms_pages = Paginator.new @rooms_count, @limit, params[:page]
    @offset ||= @rooms_pages.offset unless @rooms_pages.nil?

    if @rooms_count > 0 && !@offset.blank?
      @rooms = @rooms.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @room = Room.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @room = Room.new(floor_id: @room.floor_id, number: @room.number, name: @room.name)
    render action: 'new'
  end

  def create
    @room = Room.new()
    @room.attributes = params[:room]
    if @room.save
      flash[:notice] = t('room.action.new.success')
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
  end

  def update
    @room.attributes = params[:room]
    if @room.save
      flash[:notice] = t('room.action.edit.success')
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
    @room.destroy
    flash[:notice] = t('room.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

  def update_floors
    @floors = Floor.accessible.where(address_id: params[:address_id])
    respond_to do |format|
      format.js
    end
  end
private

  def load_lists
    load_addresses()
    load_floors()
  end

  def load_addresses
    @addresses = Address.accessible
  end
  def load_floors
    @floors = Floor.accessible.where(address_id: @room.blank? ? Address.accessible.first_or_initialize.id : @room.floor.address_id)
  end

  def find_room
    @room = Room.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def index_params
    params.permit('fid')
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'rooms', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
