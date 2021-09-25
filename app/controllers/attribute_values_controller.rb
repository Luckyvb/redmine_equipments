class AttributeValuesController < ApplicationController
  #unloadable

  before_action :find_project, :authorize
  before_action :find_attribute_value, :except => [:new, :create, :index, :update_attributable_objects]
  before_action :load_attributable, :only => [:new, :edit]

  #before_action :authorize

  def index
    @attribute_values = AttributeValue.accessible.all || []
  end

  def new
    @attribute_value = AttributeValue.new
  end

  def create
    @attribute_value = AttributeValue.new()
    @attribute_value.attributes = params[:attribute_value]
    if @attribute_value.save
      flash[:notice] = t('attribute_value.action.new.success')
      redirect_back_or_default()
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @attribute_value.attributes = params[:attribute_value]
    if @attribute_value.save
      flash[:notice] = t('attribute_value.action.edit.success')
      path_back_or_default
      redirect_back_or_default()
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @attribute_value.destroy
      flash[:notice] = t('attribute_value.action.delete.success')
      redirect_back_or_default()
  end

  def update_attributable_objects
    @attributable_objects = params[:attributable_type] == "Equipment" ? Equipment.accessible : VendorModel.accessible
    respond_to do |format|
      format.js
    end
  end
private

  def find_attribute_value
    @attribute_value = AttributeValue.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project
    @project = params[:project_id].blank? ? nil : Project.find(params[:project_id])
  end

  def load_attributable
    @attributable = !params[:type].blank? ? [{id: params[:type], name: t(params[:type].to_s.downcase+'.title', count: 1)}] : [{id: 'Equipment', name: t('equipment.title', count: 1)},{id: 'VendorModel', name: t('vendor_model.title', count: 1)}]
    av = !@attribute_value.blank? ? @attribute_value.attributable_type : params[:type]
    @attributable_objects = []
    case av
    when "Equipment"
      @attributable_objects = params[:id].blank? ? Equipment.accessible : [Equipment.find(params[:id])]
    when  "Equipment"
      @attributable_objects = VendorModel.accessible
    else
      @attributable_objects = []
    end
  end

  def redirect_back_or_default(default={:controller => 'attribute_values', :action => 'index', :project_id => @project.project[:identifier]})
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
