class VendorModel < ActiveRecord::Base
  unloadable

  self.table_name = "vendor_models"

  validates_presence_of :equipment_type_id, :vendor_id, :name
  attr_accessible :equipment_type_id, :vendor_id, :name, :pn, :site

  belongs_to :vendor
  belongs_to :equipment_type
  has_many :equipments, as: :owner

  default_scope { joins(:vendor).order('vendors.name asc', name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:global_view_catalogs, nil, global: true) || User.current.allowed_to?(:global_edit_catalogs, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  def to_s_wo_vendor
    pn.blank? ? "#{name}" : "#{name}, PN:#{pn}"
  end

  def to_s
    vendor.blank? ? to_s_wo_vendor : "#{vendor.name}, #{to_s_wo_vendor}"
  end
end