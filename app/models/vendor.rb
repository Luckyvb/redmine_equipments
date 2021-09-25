class Vendor < ActiveRecord::Base
  unloadable

  self.table_name = "vendors"

  validates_presence_of :name
  attr_accessible :name, :site#, :icon

  has_one_attached :icon

  has_many :vendor_models
  has_many :equipments, through: :vendor_model
  has_many :equipment_types, through: :vendor_model

  default_scope { order(name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

end