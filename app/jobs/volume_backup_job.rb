class VolumeBackupJob < ApplicationJob
  queue_as :default

  def perform(volume, file)
    
    pull_image("ubuntu:latest")

    container_name = generate_name
    
    c = Docker::API::Container.new
    c.create( 
      {name: container_name}, 
      {Image: "ubuntu:latest",  HostConfig: { 
        AutoRemove: true,
        Mounts: [ 
          { Type: "volume", Source: volume, Target: "/volume" }, 
          { Type: "volume", Source: "docker-backup", Target: "/backup" } ] }, 
        Cmd: ["bash", "-c", "cd /volume && tar cvf /backup/#{file}.tar ."] }
    )
    launch_container(container_name)

    StatusCheckJob.perform_later :backup, container_name, file, volume
    
  end
end