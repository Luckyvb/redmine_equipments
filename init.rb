ActiveSupport::Reloader.to_prepare do
  require 'macros'
  require 'concerns/equipments_project_extension'
  Project.send :include, EquipmentsProjectExtension
  #SettingsHelper.send :include, EquipmentsSettingsHelper
end

Redmine::Plugin.register :equipments do
  name 'Equipments plugin'
  author '!Lucky'
  description 'Add equipments inventory for Redmine'
  version '0.0.1'
  url 'https://github.com/redmine_equipments'
  author_url 'https://github.com/Luckyvb'

  #requires_redmine_plugin :fontawesome, :version_or_higher => '0.0.2'

  settings(
    default: {
     'use_fontawesome' => true,
    },
    partial: 'settings/equipments'
  )

  project_module :equipments do
    permission :global_view_equipments, {
      :equipments => [:index, :show]
    }
    permission :global_edit_equipments, {
      :equipments => [:index, :show, :new, :create, :copy, :edit, :update, :destroy]
    }
    permission :global_view_catalogs, {
      :catalogs => [:index],
      :organizations => [:index, :show],
      :attributes => [:index, :show],
      :service_types => [:index, :show],
      :service_result_types => [:index, :show],
      :countries => [:index, :show],
      :cities => [:index, :show],
      :addresses => [:index, :show],
      :floors => [:index, :show],
      :rooms => [:index, :show],
      :document_types => [:index, :show],
      :equipment_types => [:index, :show],
      :vendors => [:index, :show],
      :vendor_models => [:index, :show]
    }
    permission :global_edit_catalogs, {
      :organizations => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :attributes => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :service_types => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :service_result_types => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :countries => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :cities => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :addresses => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :floors => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :rooms => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :document_types => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :equipment_types => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :vendors => [:index, :show, :edit, :new, :copy, :create, :update, :destroy],
      :vendor_models => [:index, :show, :new, :copy, :create, :edit, :update, :destroy]
    }
    permission :project_view_equipments, {
      :equipments => [:catalogs, :index, :show],
      :services => [:index, :show],
      :service_results => [:index, :show],
      :consignment_notes => [:index, :show],
      :attribute_values => [:index, :show]
    }
    permission :project_edit_equipments, {
      :equipments => [:catalogs, :index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :services => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :service_results => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :consignment_notes => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :attribute_values => [:index, :new, :copy, :create, :show, :edit, :update, :destroy]
    }
    permission :project_view_catalogs, {
      :divisions => [:index, :show],
      :employees => [:index, :show],
      :project_organizations => [:index, :show],
      :stores => [:index, :show]
    }
    permission :project_edit_catalogs, {
      :divisions => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :employees => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :project_organizations => [:index, :show, :new, :copy, :create, :edit, :update, :destroy],
      :stores => [:index, :show, :new, :copy, :create, :edit, :update, :destroy]
    }
  end

  #  if Redmine::Plugin::registered_plugins.include?(:fontawesome)
  if Redmine::Plugin.installed?(:fontawesome)
    menu :top_menu, :equipments, { :controller => 'equipments', :action => 'index' }, :caption => '', :html => {:class => 'fa fa-memory', :title => I18n.t('equipments.title') }, :after => :projects, :if => Proc.new {User.current.admin}
  else
    menu :top_menu, :equipments, { :controller => 'equipments', :action => 'index' }, :caption => '', :html => {:class => 'icon icon-only icon-equipments', :title => 'Equipments' }, :after => :projects, :if => Proc.new {User.current.admin}
  end

  menu :project_menu, :equipments, { :controller => 'equipments', :action => 'index' }, :caption => :project_module_equipments, :after => :wiki, :param => :project_id
end

def init
  Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
    next unless /\.rb$/ =~ file
    require_dependency file
  end
end
