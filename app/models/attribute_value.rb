class AttributeValue < ActiveRecord::Base
  unloadable

  self.table_name = "attribute_values"

  validates_presence_of :attributable_type, :attributable_id, :attribute_id, :attribute_value
  attr_accessible :attributable_type, :attributable_id, :attribute_id, :attribute_value

  belongs_to :attributable, polymorphic: true
  belongs_to :attribute_name, class_name: 'Attribute', foreign_key: :attribute_id
  #belongs_to :equipment,
  #belongs_to :vendor_model

  default_scope { includes(:attribute_name).order(:attributable_type, :attributable_id, 'attributes.name asc', :attribute_value) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:project_view_equipments, nil, global: true) || User.current.allowed_to?(:project_edit_equipments, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }
end