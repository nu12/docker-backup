class RecoverController < ApplicationController
  def index
    @files = Dir.entries("/backup")
  end

  def create
    @file = params[:name] 
    @volume = params[:volume]
    VolumeRecoveryJob.perform_later @file, @volume
    ToastJob.set(wait: 1.second).perform_later "recovery-scheduled", "primary", "Volume creation was successfully scheduled. It may take some time to complete."
    render :create
  end

  def download
    file = params[:file]
    send_file "/backup/#{file}.tar", type: 'application/x-tar', status: 202
  end

  def delete
    file = params[:file]
    File.delete("/backup/#{file}.tar") if File.exist?("/backup/#{file}.tar")
    ToastJob.set(wait: 1.second).perform_later "recovery-delete", "success", "The backup file was successfully deleted."
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
end
