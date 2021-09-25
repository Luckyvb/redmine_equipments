class Division < ActiveRecord::Base
  unloadable

  self.table_name = "divisions"

  validates_presence_of :project_id, :organization_id, :location_type, :location_id, :name
  attr_accessible :project_id, :organization_id, :group_id, :location_type, :location_id, :name, :description

  belongs_to :project
  belongs_to :organization
  belongs_to :group
  belongs_to :location, polymorphic: true
  has_many :equipments

  default_scope { order(:name) }

  scope :visible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

  scope :accessible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

  def to_s
    full_name
  end
end