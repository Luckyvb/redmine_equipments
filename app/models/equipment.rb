class Equipment < ActiveRecord::Base
  unloadable

  self.table_name = "equipments"

  before_update :unsure_fields

  attr_accessible :project_id, :organization_id, :parent_id, :equipment_type_id, :vendor_model_id, :owner_type, :owner_id, :location_type, :location_id, :number, :sn, :warranty_end, :consignment_note_id, :updater_id, :description
  validates_presence_of :project_id, :organization_id, :equipment_type_id, :vendor_model_id, :owner_type, :owner_id, :location_type, :location_id, :updater_id

  has_ancestry
  belongs_to :project
  belongs_to :organization
  belongs_to :equipment_type
  belongs_to :vendor_model
  belongs_to :consignment_note
  belongs_to :owner, polymorphic: true
  belongs_to :location, polymorphic: true
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  has_many :attribute_values, as: :attributable #, polymorphic: true
  has_many :services

  acts_as_taggable

  acts_as_versioned :if_changed => [:organization_id, :parent__id, :equipment_type_id, :vendor_model_id, :owner_type, :owner_id, :location_type, :location_id, :number, :sn, :warranty_end]
  #acts_as_versioned_association :equipment_type

  default_scope { includes(:equipment_type).order('organization_id asc') }#, 'owner_type asc', 'owner_id asc', 'equipment_types.name asc') }

  scope :visible, lambda {|*args|
    joins(:project).
      where(Project.allowed_to_condition(args.shift || User.current, :project_view_equipments, *args))}

  scope :accessible, lambda {
    if User.current.allowed_to?(:project_view_equipments, nil, global: true) || User.current.allowed_to?(:project_edit_equipments, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def editable_by?(user = User.current)
    return user.allowed_to?(:project_edit_equipments, self.project)
      #|| user.allowed_to?(:manage_articles, self.project) ||
      #|| (user.allowed_to?(:manage_own_articles, self.project) && self.author_id == user.id)
  end

  def attachments_deletable?(user = User.current)
    editable_by?(user) || super(user)
  end
  def state
    if attribute_values.where(:attribute_id => 2).any?
      return -1
    end
    if services.any? && services.last.end_date.blank?
      return 10
    else
      return versions.count > 1 ? 2 : 0
    end
  end

  def state_icon
    case state
    when -1
      'trash'
    when 0
      'file-o'
    when 1
      'thimbs-o-up'
    when 10
      'wrench'
    else
      'question'
    end
  end

  def state_title
    case state
    when -1
      "Dismiss"
    when 0
      "New"
    when 1
      "Ok"
    when 10
      "At service"
    else
      "unknown"
    end
  end

  def to_s
    vendor_model.blank? ? "id:#{id} ##{number}, SN:#{sn}" : "#{vendor_model.vendor.name}, #{vendor_model.name} ##{number}, SN:#{sn}"
  end

  class Version

    #belongs_to :updater,  :class_name => 'User', :foreign_key => 'updater_id'

    # Return true if the content is the current page content
    def current_version?
      Equipment.version == self.version
    end

  end

  class Version
    belongs_to :organization
    belongs_to :equipment_type
    belongs_to :vendor_model
    belongs_to :consignment_note
    belongs_to :owner, polymorphic: true
    belongs_to :location, polymorphic: true
    belongs_to :updater, class_name: "User", foreign_key: "updater_id"
  end

  private

    def unsure_fields
      if sn == ""
        sn = nil
      end
    end

end