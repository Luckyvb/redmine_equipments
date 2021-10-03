class Store < ActiveRecord::Base
  unloadable

  self.table_name = "stores"

  attr_accessible :project_id, :organization_id, :parent_id, :name, :location_type, :location_id, :is_abstract, :responsible_type, :responsible_id
  validates_presence_of :project_id, :organization_id, :name

  has_ancestry
  belongs_to :project
  #belongs_to :project, :class_name => 'Project', :foreign_key => 'project_id'
  belongs_to :organization
  belongs_to :location, polymorphic: true
  belongs_to :responsible, :class_name => 'Principal'
  #belongs_to :responsible, polymorphic: true
  has_many :equipments

  #scope :visible, lambda {
    #:include => :project,
    #:conditions => Project.allowed_to_condition(User.current, :view_equipments, *args) } }

  scope :accessible2, lambda {|*args| {
    :include => :project,
    :conditions => Project.allowed_to_condition(args.shift || User.current, :project_view_equipments, *args)
  } }
  scope :accessible, lambda {
    #if User.current.allowed_to?(:view_equipments, @project) || User.current.allowed_to?(:edit_equipments, @project)
      all#where(project_id: @project.id)
    #else
    #  where('1 = 0')
    #end
  }

  def to_s_full
    #Rails.logger.warn Project.allowed_to_condition(User.current, :view_equipments).to_sql
    parent.blank? ? "#{name} (#{location.to_s}, #{responsible.to_s})" : "#{parent.to_s}/#{name} (#{location.to_s}, #{responsible.to_s})"
  end

  def to_s
    #Rails.logger.warn Project.allowed_to_condition(User.current, :view_equipments).to_sql
    parent.blank? ? "#{name} (#{location.name}" : "#{parent.to_s}/#{name} (#{location.name})"
  end
end