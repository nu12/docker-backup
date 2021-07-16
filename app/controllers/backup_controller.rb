class BackupController < ApplicationController
  def index
    volume = Docker::API::Volume.new
    @volumes = volume.list.json["Volumes"].sort { |a, b| a["Name"] <=> b["Name"] }
  end

  def create
    @volume = params[:name]
    @file = params[:file]
    VolumeBackupJob.perform_later @volume, @file
    flash[:primary] = "Backup for volume #{@volume} was successfully scheduled. It may take some time to complete."
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
end
