class CountriesController < ApplicationController
  unloadable

  before_action :authorize
  before_action :find_country, :except => [:new, :create, :index]

  helper :sort
  include SortHelper

  def index
    sort_init 'name', 'asc'
    sort_update 'name' => "#{Country.table_name}.name"

    @countries = Country.accessible.all || []

    @limit = per_page_option
    @countries_count = @countries.count
    @countries_pages = Paginator.new @countries_count, @limit, params[:page]
    @offset ||= @countries_pages.offset unless @countries_pages.nil?

    if @countries_count > 0 && !@offset.blank?
      @countries = @countries.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @country = Country.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    c = @country
    @country = Country.new(
      name: c.name,
      short_name: c.short_name,
      iso: c.iso
    )
    render :action => 'new'
  end

  def create
    @country = Country.new()
    @country.attributes = params[:country]
    if @country.save
      flash[:notice] = t('country.action.new.success')
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
    @country.attributes = params[:country]
    if @country.save
      flash[:notice] = t('country.action.edit.success')
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
    @country.destroy
    flash[:notice] = t('country.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

private

  def find_country
    @country = Country.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'countries', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
