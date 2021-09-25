class DocumentTypesController < ApplicationController
  unloadable

  helper :sort
  include SortHelper

  before_action :find_document_type, :except => [:new, :create, :index]

  #before_action :authorize

  def index
    sort_init [['name', 'asc']]
    sort_update 'name' => "#{DocumentType.table_name}.name" #, 'ancestry' => "concat(ifnull(ancestry,id),'/',ifnull(position,ifnull(ancestry,0)))"
    @document_types = DocumentType.accessible.all || []
    @document_types = @document_types.order(sort_clause) unless @document_types.nil?

    @limit = per_page_option
    @document_type_count = @document_types.count
    @document_type_pages = Paginator.new @document_types, @limit, params[:page]
    @offset ||= @document_types_pages.offset unless @document_types_pages.nil?

    if @document_type_count > 0 && !@offset.blank?
      @document_types = @document_types.drop(@offset).first(@limit)
    end
  end

  def new
    @document_type = DocumentType.new
  end

  def create
    @document_type = DocumentType.new()
    @document_type.attributes = params[:document_type]
    if @document_type.save
      flash[:notice] = t('document_type.action.new.success')
      redirect_to :controller => 'DocumentTypes', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @document_type.attributes = params[:document_type]
    if @document_type.save
      flash[:notice] = t('document_type.action.edit.success')
      redirect_to :controller => 'DocumentTypes', :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def show
  end

  def destroy
      @document_type.destroy
      flash[:notice] = t('document_type.action.delete.success')
      redirect_to :controller => 'DocumentTypes', :action => 'index'
  end

private

  def find_document_type
    @document_type = DocumentType.accessible.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
