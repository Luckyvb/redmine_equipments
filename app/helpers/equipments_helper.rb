include LocationsHelper
include OwnersHelper
include VendorModelsHelper
include GlobalHelper

module EquipmentsHelper

  def owner_controller_name(e)
    e.owner_type.downcase+'s'
  end

  def link_to_equipment_type(e)
    img_css = "max-width: 16px; max-height: 16px;"
    icon = !e.equipment_type.blank? && e.equipment_type.icon.attached? ? e.equipment_type.icon : nil
    title = e.equipment_type.blank? ? e.equipment_type_id : e.equipment_type.name
    link_to ( icon ? image_tag(icon, :style => img_css) : tag.i(:class => 'fas fa-cog')), {:controller => 'equipment_types', :action => 'show', :id => e.equipment_type.id}, :title => title
  end

  def link_to_vendor(e)
    icon = !e.vendor_model.blank? && !e.vendor_model.vendor.blank? && e.vendor_model.vendor.icon.attached? ? e.vendor_model.vendor.icon : nil
    img_css = "max-width: 16px; max-height: 16px;"
    title = e.vendor_model.blank? ? "" : e.vendor_model.vendor.name
    link_to (icon ? image_tag(icon, :style => img_css) : tag.i(:class => 'fas fa-copyright')), {:controller => 'vendors', :action => 'show', :id => e.vendor_model.vendor.id}, :title=>title
  end

  def fill_range_options_select_children(elements)
    options = ''
    elements.each do |e|
        if !elements[].blank? && e[].any?
          options << "<optgroup label=\"#{e.name}\">"
          options << fill_options_select_children(e[])
          options << "</optgroup>"
        else
          options << "<option value=\"#{e.id}\">#{e.name}</option>"
        end
        Rails.logger.info options
    end
    options
  end

  def path_back_or_default
    base_path_back_or_default('equipments')
  end

  def equipment_parent_options_for_select(parents, selected_id = nil, css = nil)
    #css = "select_icon #{p.equipment_type)}"
    options_for_select(@parents.map { |p| ["#{'»' * p.depth} #{p.to_s}", p.id, :'data-image' => url_for_equipment_type_icon(p.equipment_type), :class => css] }, selected_id)
  end

end
