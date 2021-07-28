class RecoverController < ApplicationController
  before_action :authenticate!
  before_action :set_files, only: [:index, :batch_all]
  def index
    @running = Task.get_running_restore
    p "===============================>> #{@files}"
  end

  def create
    process_batch(
      [ { file: params[:name] , volume: params[:volume] } ],
      "Volume creation was successfully scheduled. It may take some time to complete.")
    redirect_to restore_list_path
  end

  def batch_all
    process_batch(
      @files.map{ | file | { file: file[:full_name], volume: file[:short_name] } },
      "Volume creation was successfully scheduled. It may take some time to complete.")
    redirect_to restore_list_path
  end

  def batch_selected
    process_batch(
      params[:files].map { |file| { file: "#{file}.tar", volume: file } },
      "Volume creation was successfully scheduled. It may take some time to complete.")
    redirect_to restore_list_path
  end

  def download
    file = params[:file]
    send_file "/backup/#{file}.tar", type: 'application/x-tar', status: 202
  end

  def delete
    file = params[:file]
    File.delete("/backup/#{file}.tar") if File.exist?("/backup/#{file}.tar")
    flash[:success] = "The backup file was successfully deleted."
    redirect_to restore_list_path
  end

  def upload
  end

  def save
    params[:file].each do |uploaded_io| 
      File.open(Rails.root.join('/backup', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
    redirect_to restore_list_path
  end

  private

  def set_files
    @files = Dir.entries("/backup").select{|el| el != "." && el != ".."}.map{ | f | { full_name: f, short_name: f.split(".")[0] } }
  end

  def process_batch list, msg
    list.each do |item|
      VolumeRecoveryJob.perform_later item[:file], item[:volume]
      Task.add_restore "#{item[:file]}"
    end
    flash[:primary] = msg
  end
end
