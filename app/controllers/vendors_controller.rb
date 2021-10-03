require 'open-uri'

class VendorsController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :authorize
  before_action :find_vendor, :except => [:new, :create, :index]

  def index
    sort_init 'name', 'asc'
    sort_update 'name' => "#{Vendor.table_name}.name", 'site' => "#{Vendor.table_name}.site"

    name = params[:name]

    if name
      @vendors = Vendor.accessible.where(name: name) || []
    else
      @vendors = Vendor.accessible.all || []
    end
    @vendors = @vendors.order(sort_clause) unless @vendors.nil?

    @limit = per_page_option
    @v_count = @vendors.count
    @v_pages = Paginator.new @v_count, @limit, params[:page]
    @offset ||= @v_pages.offset unless @v_pages.nil?

    if @v_count > 0 && !@offset.blank?
      @vendors = @vendors.drop(@offset).first(@limit)
    end
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @vendor = Vendor.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @vendor = Vendor.new(name: @vendor.name, icon: @vendor.icon, site: @vendor.site)
    render action: 'new'
  end

  def create
    @vendor = Vendor.new()
    @vendor.attributes = params[:vendor]
    if @vendor.save
      get_site_icon(@vendor)
      flash[:notice] = t('vendor.action.new.success')
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
    @vendor.attributes = params[:vendor]
    if @vendor.save
      get_site_icon(@vendor)
      Rails.logger.warn @vendor.icon.inspect
      Rails.logger.warn @vendor.icon.attached?
      flash[:notice] = t('vendor.action.edit.success')
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
    @vendor.destroy
    flash[:notice] = t('vendor.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'index'
  end

private

  def find_vendor
    @vendor = Vendor.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_site_icon(vendor)
    url = "https://www.google.com/s2/favicons?domain=#{vendor.site}"
    download = URI.open(url) #open(url)
    #if download.status == 200
      type = download.meta["content-type"]
      ext = type.split("/")
      Rails.logger.warn "Vendor icon: #{type}, filename: vendor_#{vendor.id}.#{ext[ext.length-1]}"
      vendor.icon.attach(io: download, filename: "vendor_#{vendor.id}.#{ext[ext.length-1]}", content_type: type)
    #end
  rescue => e
    flash[:error] = "Save Icon #{t('error')}:#{e.message}"
  end

  def authorize(ctrl = params[:controller], action = params[:action], global = true)
    User.current.allowed_to?({:controller => ctrl, :action => action}, nil, :global => true)
  end

  def redirect_back_or_default(default = {:controller => 'vendors', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end
end
