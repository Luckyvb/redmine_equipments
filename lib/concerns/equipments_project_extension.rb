module EquipmentsProjectExtension
  extend ActiveSupport::Concern
  included do
    has_many :equipments, :class_name => "Equipment", :foreign_key => "project_id"
    has_many :stores, :class_name => "Store", :foreign_key => "project_id"
    has_many :employees, :class_name => "Employee", :foreign_key => "project_id"
    has_many :project_organizations, :class_name => "ProjectOrganizations", :foreign_key => "project_id"
  end
end
