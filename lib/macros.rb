include EquipmentLinkHelper
module Macros

 Redmine::WikiFormatting::Macros.register do

    desc "Hardware link Macro, using the hw# format"
    macro :hw do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      hw = Equipment.where(project_id: @project.id, number: args.first).first
      link_to_equipment_by_number(hw, args)
    end

    desc "Hardware link Macro, using the hw# format"
    macro :equipment do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      hw = Equipment.where(project_id: @project.id, number: args.first).first
      link_to_equipment_by_number(hw, args)
    end

    desc "Hardware link Macro, using the hw_id# format"
    macro :hw_id do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      hw = Equipment.find(args.first)
      link_to_equipment_by_id(hw, args)
    end

   desc "Hardware link Macro, using the hw_id# format"
   macro :hw_sn do |obj, args|
     args, options = extract_macro_options(args, :parent)
     raise 'No or bad arguments.' if args.size != 1
     hw = Equipment.find(args.first)
     link_to_equipment_by_sn(hw, args)
   end

    desc "Hardware link Macro, using the hardware# format"
    macro :hardware do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      hw = Equipment.where(project_id: @project.id, number: args.first).first
      link_to_equipment_by_number(h, args)
    end

    desc "Hardware List by Type link Macro, using the category# format"
    macro :hw_by_type do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      type = EquipmentType.find(args.first)
      link_to_equipment_by_type_with_title(type, args)
    end

   desc "Hardware link Macro, using the hw_id# format"
   macro :service do |obj, args|
     args, options = extract_macro_options(args, :parent)
     raise 'No or bad arguments.' if args.size != 1
     s = Service.find(args.first)
     link_to_service(s, args)
   end

 end
end
