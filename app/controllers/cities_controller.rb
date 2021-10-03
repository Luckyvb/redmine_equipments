class CitiesController < ApplicationController
  unloadable

  before_action :authorize
  before_action :find_city, :except => [:new, :create, :index]
  before_action :load_lists, :except => [:create, :index]

  helper :sort
  include SortHelper

  def index
    sort_init 'name', 'asc'
    sort_update 'name' => "#{City.table_name}.name"

    @cities = City.accessible.all || []

    @limit = per_page_option
    @cities_count = @cities.count
    @cities_pages = Paginator.new @cities_count, @limit, params[:page]
    @offset ||= @cities_pages.offset unless @cities_pages.nil?

    if @cities_count > 0 && !@offset.blank?
      @cities = @cities.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @city = City.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    c = @city
    @city = City.new(
      city_id: c.city_id,
      name: c.name
    )
    render :action => 'new'
  end

  def create
    @city = City.new()
    @city.attributes = params[:city]
    if @city.save
      flash[:notice] = t('city.action.new.success')
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
    @city.attributes = params[:city]
    if @city.save
      flash[:notice] = t('city.action.edit.success')
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
    @city.destroy
    flash[:notice] = t('city.action.delete.success')
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
    #load_addresses()
    #load_floors()
  end

  def load_addresses
    @addresses = Address.accessible
  end
  def load_floors
    @floors = Floor.accessible.where(address_id: @city.blank? ? Address.accessible.first_or_initialize.id : @city.floor.address_id)
  end

  def find_city
    @city = City.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'cities', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
