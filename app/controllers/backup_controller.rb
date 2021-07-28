class BackupController < ApplicationController
  before_action :authenticate!
  before_action :set_volumes, only: [:index, :batch_all]
  def index
    @running = Task.get_running_backup
  end

  def create
    volume = params[:name]
    file = params[:file]
    process_batch( 
      [ { volume: volume, file: file} ],
      "Backup for volume #{volume} was successfully scheduled. It may take some time to complete.")
    redirect_to volume_list_path
  end

  def batch_all
    process_batch( 
      @volumes.map{ | volume | { volume: volume["Name"] , file: volume["Name"] } },
      "Backups for all volumes were successfully scheduled. It may take some time to complete.")
    redirect_to volume_list_path
  end

  def batch_selected
    process_batch( 
      params[:volumes].map{ | volume_name | { volume: volume_name , file: volume_name } },
      "Backups for selected volumes were successfully scheduled. It may take some time to complete.")
    redirect_to volume_list_path
  end

  def delete
    name = params[:id]
    v = Docker::API::Volume.new
    r = v.remove(name)
    if r.success?
      flash[:success] = "Volume successfully deleted."
    else
      flash[:danger] = r.json["message"]
    end
    redirect_to volume_list_path
  end

  private

  def set_volumes
    volume = Docker::API::Volume.new
    @volumes = volume.list.json["Volumes"].sort { |a, b| a["Name"] <=> b["Name"] }.filter { |v| v["Name"] != "docker-backup" }
  end

  def process_batch list, msg
    list.each do |item|
      VolumeBackupJob.perform_later item[:volume], item[:file]
      Task.add_backup item[:volume]
    end
    flash[:primary] = msg
  end
end
