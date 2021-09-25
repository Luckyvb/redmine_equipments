class Employee < ActiveRecord::Base
  unloadable

  self.table_name = "employees"

  validates_presence_of :project_id,:organization_id,:location_type,:location_id,:full_name
  attr_accessible :project_id, :organization_id, :user_id, :location_type, :location_id, :full_name, :description

  belongs_to :project
  belongs_to :organization
  belongs_to :user
  belongs_to :location, polymorphic: true
  has_many :equipments

  default_scope { order(:full_name) }

  scope :visible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

  scope :accessible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

  def to_s
    full_name
  end
end