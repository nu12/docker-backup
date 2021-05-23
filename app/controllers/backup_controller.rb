class BackupController < ApplicationController
  def index
    volume = Docker::API::Volume.new
    @volumes = volume.list.json["Volumes"].sort { |a, b| a["Name"] <=> b["Name"] }
  end

  def new
    @name = params[:name]
  end

  def create
    create_tar_file(params[:name], params[:file])
    redirect_to volume_path
  end

  private

  def create_tar_file(volume, file)
    pull_image("ubuntu:latest")
    
    c = Docker::API::Container.new
    c.create( 
      {name: "docker-backup"}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "volume", Source: "docker-backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar cvf /backup/#{file}.tar ."] }
    )
    launch_container("docker-backup")
  end
end
