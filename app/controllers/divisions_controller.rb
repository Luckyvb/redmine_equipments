class DivisionsController < ApplicationController
  unloadable

  before_action :authorize
  before_action :find_division, :except => [:new, :create, :index]

  def index
    @divisions = Division.accessible.all || []
  end

  def new
    @division = Division.new
  end

  def create
    @division = Division.new
    @division.attributes = params[:division]
    if @division.save
      flash[:notice] = t('division.action.new.success')
      redirect_back_or_default({:controller => 'divisions', :action => 'index', :project_id => @division.project[:identifier]})
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @division.attributes = params[:division]
    if @division.save
      flash[:notice] = t('division.action.edit.success')
      redirect_back_or_default({:controller => 'divisions', :action => 'index', :project_id => @division.project[:identifier]})
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @division.destroy
      flash[:notice] = t('division.action.delete.success')
      redirect_back_or_default({:controller => 'divisions', :action => 'index', :project_id => @division.project[:identifier]})
  end
private

  def find_division
    @division = Division.accessible.find(params[:id])
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
