class BackupController < ApplicationController
  before_action :set_volumes, only: [:index, :batch_all]
  def index
  end

  def create
    @volume = params[:name]
    @file = params[:file]
    VolumeBackupJob.perform_later @volume, @file
    flash[:primary] = "Backup for volume #{@volume} was successfully scheduled. It may take some time to complete."
    redirect_to volume_path
  end

  def batch_all
    @volumes.each do |volume|
      VolumeBackupJob.perform_later volume["Name"], volume["Name"]
    end
    flash[:primary] = "Backups for all volumes were successfully scheduled. It may take some time to complete."
    redirect_to volume_path
  end

  def batch_selected
    selected = params[:volumes]
    selected.each do |name|
      VolumeBackupJob.perform_later name, name
    end
    flash[:primary] = "Backups for selected volumes were successfully scheduled. It may take some time to complete."
    redirect_to volume_path
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
    redirect_to volume_path
  end

  private

  def set_volumes
    volume = Docker::API::Volume.new
    @volumes = volume.list.json["Volumes"].sort { |a, b| a["Name"] <=> b["Name"] }.filter { |v| v["Name"] != "docker-backup" }
  end
end
