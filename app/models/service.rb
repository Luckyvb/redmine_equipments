class Service < ActiveRecord::Base
  unloadable

  self.table_name = "services"

  validates_presence_of :project_id, :equipment_id, :organization_id, :service_type_id, :start_date, :send_by_id
  attr_accessible :project_id, :equipment_id, :organization_id, :service_type_id, :start_date, :end_date, :send_by_id, :return_by_id, :document_number, :description

  belongs_to :project
  belongs_to :organization
  belongs_to :equipment
  belongs_to :service_type
  belongs_to :send_by, class_name: 'User', foreign_key: 'send_by_id'
  belongs_to :return_by, class_name: 'User', foreign_key: 'return_by_id'
  has_many :service_results

  acts_as_attachable

  #default_scope { joins(:vendor).order('vendors.name asc', name: :asc) }

  scope :accessible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

  def attachments_visible?(user = User.current)
    user.allowed_to?(:project_view_catalogs, self.project, global: false) || user.allowed_to?(:project_edit_catalogs, self.project, global: false)
  end

  def attachments_editable?(user = User.current)
    user.allowed_to?(:project_edit_catalogs, self.project, global: false)
  end

  def attachments_deletable?(user = User.current)
    attachments_editable?(user)
  end

  def to_s
    equipment.blank? ? "id:#{id} ##{organization.name}, #{l("service.attr.service_type")}:#{service_type.to_s}" : "#{equipment.to_s}, #{organization.name}, #{l("service.attr.service_type")}:#{service_type.to_s}, #:#{document_number || "-"}"
  end
end