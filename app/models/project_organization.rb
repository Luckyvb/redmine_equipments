class ProjectOrganization < ActiveRecord::Base
  unloadable

  self.table_name = "project_organizations"

  validates_presence_of :project_id, :organization_id
  attr_accessible :project_id, :organization_id, :description

  belongs_to :project
  belongs_to :organization

  default_scope { order(project_id: :asc, organization_id: :asc) }

  scope :accessible, lambda {
    #if User.current.allowed_to?(:project_view_catalogs, @project, global: false) || User.current.allowed_to?(:project_edit_catalogs, @project, global: false)
      all
    #else
    #  where('1 = 0')
    #end
  }

  def to_s
    name
  end
end