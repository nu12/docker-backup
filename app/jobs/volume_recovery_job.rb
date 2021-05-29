class VolumeRecoveryJob < ApplicationJob
  queue_as :default

  def perform(file, volume)
    v = Docker::API::Volume.new
    v.create(Name: volume)

    pull_image("ubuntu:latest")

    container_name = generate_name
  
    c = Docker::API::Container.new
    c.create( 
      {name: container_name}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "volume", Source: "docker-backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar xvf /backup/#{file}"] }
    )
    launch_container(container_name)
  end
end
