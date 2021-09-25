require 'json'
require 'zip'

class EquipmentsSettingsController < ApplicationController
  unloadable
  menu_item :equipments_settings

  layout 'admin'
  before_action :require_admin

  def index
  end

  def save
    Setting.send "plugin_equipments=", params[:settings]
    redirect_to '/admin/equipments', notice: t('settings.notice.saved')
  end

  def backup
    # @json_string = Setting['plugin_equipments'].to_json
    # Rails.logger.info @json_string
    #
    # fname = "backup.zip"
    # temp_file = Tempfile.new(fname)
    # tmp_fname = temp_file.path
    # temp_file.close
    #
    # Zip::File.open(tmp_fname, Zip::File::CREATE) do |zip_file|
    #   zip_file.file.open('equipments.json', 'w') { |f1| f1 << @json_string }
    # end
    #
    # zip_data = IO.binread(tmp_fname)
    #
    # send_data zip_data, :type => 'application/zip', :disposition => "attachment; filename=#{fname}"
  end

  def restore
    # if !params[:file].blank? && !params[:file].tempfile.blank? && File.exists?(params[:file].tempfile.to_path.to_s)
    #   Zip::File.open(params[:file].tempfile.to_path.to_s) do |zipfile|
    #     zipfile.each do |file|
    #       if file.name == 'equipments.json'
    #         tempfile = Tempfile.new('equipments.json')
    #         file.extract(tempfile.path) { true }
    #         if File.exists? tempfile.path
    #           f = File.read tempfile.path
    #           s = JSON.parse(f)
    #           Rails.logger.info s
    #           File.delete tempfile.path
    #           Setting.send "plugin_equipments=", s
    #         else
    #           redirect_to '/admin/equipments', error: t('settings.restore.error')
    #         end
    #       end
    #     end
    #   end
    #end

    redirect_to '/admin/equipments', notice: t('settings.restore.notice')
  end

end
