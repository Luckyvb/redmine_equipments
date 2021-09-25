class ServiceResult < ActiveRecord::Base
  unloadable

  self.table_name = "service_results"

  validates_presence_of :service_id, :service_result_type_id, :responsible_id, :date, :value
  attr_accessible :service_id, :service_result_type_id, :responsible_id, :date, :value, :description

  belongs_to :service
  belongs_to :service_result_type
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id'

  delegate :project, :to => :service, :allow_nil => true

  acts_as_attachable

  #default_scope { joins(:service).order('services.name asc', name: :asc) }

  scope :accessible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_equipment, *args))}

  def attachments_visible?(user = User.current)
    user.allowed_to?(:project_view_equipment, self.project, global: false) || user.allowed_to?(:project_edit_equipment, self.project, global: false)
  end

  def attachments_editable?(user = User.current)
    user.allowed_to?(:project_edit_equipment, self.project, global: false)
  end

  def attachments_deletable?(user = User.current)
    attachments_editable?(user)
  end

  #def to_s
  #  vendor.blank? ? "id:#{id} ##{name}, PN:#{pn}" : "#{vendor.name}, #{name} PN:#{pn}"
  #end
end