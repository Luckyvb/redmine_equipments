module EquipmentLinkHelper

  def link_to_equipment_by_number(equipment, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 1)}: #:#{equipment.number}", {:controller => 'equipments', :action => 'show', :project_id => equipment.project.identifier, :id => equipment.id}, :class => 'icon-equipments', :title => equipment.to_s
    else
      link_to "#{t('equipment.title', count: 1)}: #:#{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_equipment_by_id(equipment, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 1)}: #{equipment.id}", {:controller => 'equipments', :action => 'show', :project_id => equipment.project.identifier, :id => equipment.id}, :class => 'icon-equipments', :title => equipment.to_s
    else
      link_to "#{t('equipment.title', count: 1)}: #{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_equipment_by_sn(equipment, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 1)}, SN:#{equipment.sn}", {:controller => 'equipments', :action => 'show', :project_id => equipment.project.identifier, :id => equipment.id}, :class => 'icon-equipments', :title => equipment.to_s
    else
      link_to "#{t('equipment.title', count: 1)}: SN:#{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_equipment_by_id(equipment, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 1)}: #{equipment.id}", {:controller => 'equipments', :action => 'show', :project_id => equipment.project.identifier, :id => equipment.id}, :class => 'icon-equipments', :title => equipment.to_s
    else
      link_to "#{t('equipment.title', count: 1)}: #{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_equipment_with_title(equipment, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 2)}: #{equipment.to_s}", {:controller => 'equipments', :action => 'show', :project_id => equipment.project.identifier, :id => equipment.id}, :class => 'icon-equipments'
    else
      link_to "#{t('equipment.title', count: 1)}: #{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_equipment_by_type_with_title(type, args)
    if !equipment.blank?
      link_to "#{t('equipment.title', count: 2)}: #{type.name}", {:controller => 'equipments', :action => 'index', :project_id => @project.identifier, :type => type.name}, :class => 'icon-equipments'
    else
      link_to "#{t('equipment.title', count: 1)}: #{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :type => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

  def link_to_service(service, args)
    if !service.blank?
      link_to "#{t('service.title', count: 1)}: #{service.id}", {:controller => 'services', :action => 'show', :project_id => service.project.identifier, :id => service.id}, :class => 'icon-equipments', :title => service.to_s
    else
      link_to "#{t('service.title', count: 1)}: #{args.first.to_s}: #{t('equipment.not_found')}", {:controller => 'equipments', :action => 'show', :project_id => @project.identifier, :id => args.first.to_s}, :class => 'icon-equipments error', :title => args.first.to_s
    end
  end

end
