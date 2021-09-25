class EquipmentsHookListener < Redmine::Hook::ViewListener

  def view_layouts_base_html_head(_context = {})
    header = stylesheet_link_tag('equipments.css', :plugin => 'equipments', :media => 'all')
    header += javascript_include_tag('equipments.js', :plugin => 'equipments')
    header += javascript_include_tag('equipmentsEditor.js', :plugin => 'equipments')
    header += javascript_include_tag('lang/equipments_js-toolbar-en.js', :plugin => 'equipments')
    header += javascript_include_tag("lang/equipments_js-toolbar-#{current_language.to_s.downcase}.js", :plugin => "redmine_equipments") if lang_supported? current_language.to_s.downcase
    header += javascript_include_tag('equipments_js-toolbar.js', :plugin => 'equipments') unless ckeditor_enabled?
    header
  end

  def ckeditor_enabled?
    Setting.text_formatting == "CKEditor"
  end

  def lang_supported? lang
    return false if lang == 'en' # English is always loaded, avoid double load
    File.exist? "#{File.expand_path('../../../../assets/javascripts/lang', __FILE__)}/equipments_js-toolbar-#{lang}.js"
  end

end
