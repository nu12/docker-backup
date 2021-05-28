class VolumeRecoveryJob < ApplicationJob
  queue_as :default

  def perform(file, volume)
    v = Docker::API::Volume.new
    v.create(Name: volume)

    pull_image("ubuntu:latest")
  
    c = Docker::API::Container.new
    c.create( 
      {name: "docker-recover"}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "volume", Source: "docker-backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar xvf /backup/#{file}"] }
    )
    launch_container("docker-recover")
  end
end
