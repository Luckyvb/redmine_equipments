class EmployeesController < ApplicationController
  unloadable

  before_action :authorize
  before_action :find_employee, :except => [:new, :create, :index]

  def index
    @employees = Employee.accessible.all || []
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new
    @employee.attributes = params[:employee]
    if @employee.save
      flash[:notice] = t('employee.action.new.success')
      redirect_back_or_default({:controller => 'employees', :action => 'index', :project_id => @employee.project[:identifier]})
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @employee.attributes = params[:employee]
    if @employee.save
      flash[:notice] = t('employee.action.edit.success')
      redirect_back_or_default({:controller => 'employees', :action => 'index', :project_id => @employee.project[:identifier]})
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @employee.destroy
      flash[:notice] = t('employee.action.delete.success')
      redirect_back_or_default({:controller => 'employees', :action => 'index', :project_id => @employee.project[:identifier]})
  end

  def update_floors
    #@floors = Floor.accessible.where(address_id: params[:address_id])
    #respond_to do |format|
    #  format.js
    #end
  end
private

  def load_lists
    load_countries()
    load_cities()
    load_addresses()
    load_floors()
  end

  def load_countries
    @countries = Contry.accessible
  end
  def load_cities
    @cities = City.accessible
  end
  def load_addresses
    @addresses = Address.accessible
  end
  def load_floors
    @floors = Floor.accessible.where(address_id: @employee.blank? ? Address.accessible.first_or_initialize.id : @employee.floor.address_id)
  end

  def find_employee
    @employee = Employee.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redirect_back_or_default(default)
    if session[:return_to] == request.env["HTTP_REFERER"]
      redirect_back(fallback_location: default )
    else
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end

end
