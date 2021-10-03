class FloorsController < ApplicationController
  unloadable

  before_action :find_floor, :except => [:new, :create, :index]

  #before_action :authorize

  helper :sort
  include SortHelper

  def index
    sort_init 'name', 'asc'
    sort_update 'name' => "#{Floor.table_name}.name"

    @floors = Floor.accessible.all || []

    @limit = per_page_option
    @floors_count = @floors.count
    @floors_pages = Paginator.new @floors_count, @limit, params[:page]
    @offset ||= @floors_pages.offset unless @floors_pages.nil?

    if @floors_count > 0 && !@offset.blank?
      @floors = @floors.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @floor = Floor.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @floor = Floor.new(
      address_id: @floor.address_id,
      number: @floor.number,
      name: @floor.name
    )
    render action: 'new'
  end

  def create
    session[:return_to] = request.env["HTTP_REFERER"]
    @floor = Floor.new()
    @floor.attributes = params[:floor]
    if @floor.save
      flash[:notice] = t('floor.action.new.success')
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
    @floor.attributes = params[:floor]
    if @floor.save
      flash[:notice] = t('floor.action.edit.success')
      redirect_back_or_default
    else
      render :action => 'edit'
    end
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

  def show
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def destroy
    session[:return_to] = request.env["HTTP_REFERER"]
    @floor.destroy
    flash[:notice] = t('floor.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

private

  def find_floor
    @floor = Floor.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redirect_back_or_default(default = {:controller => 'floors', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
