class AttributesController < ApplicationController
  unloadable

  before_action :find_attribute, :except => [:new, :create, :index]

  #before_action :authorize

  def index
    @attributes = Attribute.accessible.all || []
  end

  def new
    @attribute = Attribute.new
  end

  def create
    @attribute = Attribute.new()
    @attribute.attributes = params[:attribute]
    if @attribute.save
      flash[:notice] = t('attribute.action.new.success')
      redirect_to :controller => 'attributes', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @attribute.attributes = params[:attribute]
    if @attribute.save
      flash[:notice] = t('attribute.action.edit.success')
      redirect_to :controller => 'attributes', :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @attribute.destroy
      flash[:notice] = t('attribute.action.delete.success')
      redirect_to :controller => 'attributes', :action => 'index'
  end

private

  def find_attribute
    @attribute = Attribute.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
