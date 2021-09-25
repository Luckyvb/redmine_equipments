class AddressesController < ApplicationController
  unloadable

  before_action :find_address, :except => [:new, :create, :index]

  #before_action :authorize

  def index
    @addresses = Address.accessible.all || []
  end

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @address = Address.new
  end

  def copy
    session[:return_to] = request.env["HTTP_REFERER"]
    @address = Address.new(
      city_id: @address.city_id,
      name: @address.name,
      coordinates: @address.coordinates
    )
    render action: 'new'
  end

  def create
    @address = Address.new()
    @address.attributes = params[:address]
    if @address.save
      flash[:notice] = t('address.action.new.success')
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
    @address.attributes = params[:address]
    if @address.save
      flash[:notice] = t('address.action.edit.success')
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
    @address.destroy
    flash[:notice] = t('address.action.delete.success')
    redirect_back_or_default
  rescue => e
    flash[:error] = "#{t('error')}:#{e.message}"
    render :action => 'new'
  end

private

  def find_address
    @address = Address.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redirect_back_or_default(default = {:controller => 'addresses', :action => 'index'})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
