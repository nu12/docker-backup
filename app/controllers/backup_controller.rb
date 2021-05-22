class BackupController < ApplicationController
  def index
    volume = Docker::API::Volume.new
    @volumes = volume.list.json["Volumes"]
  end

  def new
    @name = params[:name]
  end

  def create
    volume = params[:name]
    file = params[:file]

    i = Docker::API::Image.new
    i.create( fromImage: "ubuntu:latest" )
    
    c = Docker::API::Container.new
    c.create( 
      {name: "docker-backup"}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "bind", Source: "/backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar cvf /backup/#{file}.tar ."] }
    )
    c.start("docker-backup")
    c.wait("docker-backup")
    c.remove("docker-backup")

    redirect_to volume_path
  end
end
