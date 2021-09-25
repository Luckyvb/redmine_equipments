class RoomTenant < ActiveRecord::Base
  unloadable

  self.table_name = "room_tenants"

  validates_presence_of :room_id, :organization_id, :start_date
  attr_accessible :room_id, :organization_id, :start_date, :end_date, :description

  belongs_to :room
  belongs_to :organization

  #default_scope { joins(:vendor).order('vendors.name asc', name: :asc) }

  scope :accessible, lambda {
    if User.current.allowed_to?(:project_view_equipments, nil, global: true) || User.current.allowed_to?(:project_edit_equipments, nil, global: true)
      all
    else
      where('1 = 0')
    end
  }

  #def to_s
  #  vendor.blank? ? "id:#{id} ##{name}, PN:#{pn}" : "#{vendor.name}, #{name} PN:#{pn}"
  #end
end