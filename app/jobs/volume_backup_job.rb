class VolumeBackupJob < ApplicationJob
  queue_as :default

  def perform(volume, file)
    
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
