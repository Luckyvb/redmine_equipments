class CitiesController < ApplicationController
  unloadable

  before_action :find_city, :except => [:new, :create, :index]
  before_action :load_lists, :except => [:create, :index]

  #before_action :authorize

  def index
    @cities = City.accessible.all || []
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new()
    @city.attributes = params[:city]
    if @city.save
      flash[:notice] = t('city.action.new.success')
      redirect_to :controller => 'Cities', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @city.attributes = params[:city]
    if @city.save
      flash[:notice] = t('city.action.edit.success')
      redirect_to :controller => 'Cities', :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @city.destroy
      flash[:notice] = t('city.action.delete.success')
      redirect_to :controller => 'Cities', :action => 'index'
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

end
