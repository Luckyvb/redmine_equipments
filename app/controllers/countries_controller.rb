class CountriesController < ApplicationController
  unloadable

  before_action :find_country, :except => [:new, :create, :index]

  #before_action :authorize

  def index
    @countries = Country.accessible.all || []
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new()
    @country.attributes = params[:country]
    if @country.save
      flash[:notice] = t('country.action.new.success')
      redirect_to :controller => 'Countries', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @country.attributes = params[:country]
    if @country.save
      flash[:notice] = t('country.action.edit.success')
      redirect_to :controller => 'Countries', :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @country.destroy
      flash[:notice] = t('country.action.delete.success')
      redirect_to :controller => 'Countries', :action => 'index'
  end

private

  def find_country
    @country = Country.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
