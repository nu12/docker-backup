class RecoverController < ApplicationController
  before_action :set_files, only: [:index, :batch_all]
  def index
  end

  def create
    @file = params[:name] 
    @volume = params[:volume]
    VolumeRecoveryJob.perform_later @file, @volume
    flash[:primary] = "Volume creation was successfully scheduled. It may take some time to complete."
    redirect_to recover_path
  end

  def batch_all
    @files.each do |file|
      volume_name = file.split(".")[0]
      VolumeRecoveryJob.perform_later file, volume_name
    end
    flash[:primary] = "Volume creation was successfully scheduled. It may take some time to complete."
    redirect_to recover_path
  end

  def download
    file = params[:file]
    send_file "/backup/#{file}.tar", type: 'application/x-tar', status: 202
  end

  def delete
    file = params[:file]
    File.delete("/backup/#{file}.tar") if File.exist?("/backup/#{file}.tar")
    flash[:success] = "The backup file was successfully deleted."
    redirect_to recover_path
  end

  def upload
  end

  def save
    params[:file].each do |uploaded_io| 
      File.open(Rails.root.join('/backup', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
    redirect_to recover_path
  end

  private

  def set_files
    @files = Dir.entries("/backup").select{|el| el != "." && el != ".."}
  end
end
