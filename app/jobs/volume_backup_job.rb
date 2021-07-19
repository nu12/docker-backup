class VolumeBackupJob < ApplicationJob
  queue_as :default

  def perform(volume, file)
    v = Docker::API::Volume.new
    response = v.details("docker-backup")

    if response.status != 200
      IconJob.set(wait: 1.second).perform_later file, '<i class="fas fa-exclamation-triangle text-danger">Volume named "docker-backup" not found.<br /> <a href="/setup.html">Learn more</a> .</i>'
      return
    end
    
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
    IconJob.perform_now volume, '<i class="far fa-clock"></i>'
    
  end
end