class RecoverController < ApplicationController
  def index
    @files = Dir.entries("/backup")
  end

  def new
    @name = params[:name]
  end

  def create
    file = params[:name]
    volume = params[:volume]

    v = Docker::API::Volume.new
    v.create(Name: volume)

    i = Docker::API::Image.new
    i.create( fromImage: "ubuntu:latest" )
  
    c = Docker::API::Container.new
    c.create( 
      {name: "docker-recover"}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "volume", Source: "docker-backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar xvf /backup/#{file}.tar"] }
    )
    c.start("docker-recover")
    c.wait("docker-recover")
    c.remove("docker-recover")

    redirect_to recover_path
  end

  def download
    file = params[:file]
    send_file "/backup/#{file}.tar", type: 'application/x-tar', status: 202
  end

  def delete
    file = params[:file]
    File.delete("/backup/#{file}.tar") if File.exist?("/backup/#{file}.tar")
    redirect_to recover_path
  end

  def upload
  end

  def save
    uploaded_io = params[:file]
    File.open(Rails.root.join('/backup', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    redirect_to recover_path
  end
end
