module VendorModelsHelper

  def vm_equipment_type_options_for_select(equipment_types, selected = nil, disabled = nil)
    equipment_type_options_for_select(equipment_types, selected, disabled)
  end

  def equipment_type_options_for_select(et, selected = nil, disabled = nil)
    et_default_image = "#{Redmine::Utils.relative_url_root}/plugin_assets/equipments/images/equipment_type.svg"
    "<options>#{fill_ancestry_options(et, selected, disabled, et_default_image)}</options>".html_safe
  end

  def fill_ancestry_options(elements, selected = nil, disabled = nil, default_img = nil, level=0)
    et_default_image = "#{Redmine::Utils.relative_url_root}/plugin_assets/equipments/images/equipment_type.svg"
    options = ''
    elements.each do |e|
      if !e['children'].blank? && e['children'].any?
        options << "<optgroup label=\"#{'&nbsp;&nbsp;&nbsp;' * level}#{e['name']}\" data-image=\"#{e['icon_url'] && e['icon_url'] != "" ? e['icon_url'] : default_img}\">"
        options << fill_ancestry_options(e['children'], selected, disabled, default_img, level+1)
        options << "</optgroup>"
      else
        s = " selected=\"selected\"" if !selected.blank? && selected == e['id']
        d = " disabled=\"disabled\"" if !disabled.blank? && disabled.to_i == e['id']
        options << "<option value=\"#{e['id']}\" data-image=\"#{e['icon_url'] && e['icon_url'] != "" ? e['icon_url'] : default_img}\"#{s}#{d}>#{'&nbsp;' * level}#{e['name']}</option>"
      end
    end
    options
  end

  def vm_equipment_type_ancestry_options_bad(items, selected = nil, disabled = nil, level=0)
    options = ''
    items.each do |e|
      s = " selected=\"selected\"" if !selected.blank? && selected == e['id']
      d = " disabled=\"disabled\"" if !disabled.blank? && disabled.to_i == e['id']
      options << "<option value=\"#{e['id']}\"#{s}#{d} class=\"options-group-lvl-#{level}\">#{e['name']}</option>"
      options << vm_equipment_type_ancestry_options_bad(e['children'], selected, disabled, level+1) if !e['children'].blank? && e['children'].any?
    end
    options
  end

  def url_for_equipment_type_icon(et)
    icon = !et.blank? && et.icon.attached? ? url_for(et.icon).to_s : "#{Redmine::Utils.relative_url_root}/plugin_assets/equipments/images/equipment_type.svg"
  end

  def url_for_vendor_icon(v)
    icon = !v.blank? && v.icon.attached? ? url_for(v.icon).to_s : "#{Redmine::Utils.relative_url_root}/plugin_assets/equipments/images/vendor.svg"
  end

end
