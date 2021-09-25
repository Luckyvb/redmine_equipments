class ConsignmentNote < ActiveRecord::Base
  unloadable

  self.table_name = "consignment_notes"

  validates_presence_of :project_id, :organization_id, :seller_id, :document_type_id, :number, :date
  attr_accessible :project_id, :organization_id, :seller_id, :document_type_id, :number, :date, :is_locked, :total, :description

  belongs_to :project
  belongs_to :organization
  belongs_to :seller, class_name: "Organization", foreign_key: "seller_id"
  belongs_to :document_type

  has_many :equipments

  acts_as_attachable

  default_scope { order(organization_id: :asc, date: :desc, number: :asc) }

  scope :visible, lambda {|*args|
    joins(:project).where(Project.allowed_to_condition(args.shift || User.current, :project_view_catalogs, *args))}

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
    "#{number}, #{date}, #{seller.name})"
  end
end