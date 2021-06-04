class VolumeRecoveryJob < ApplicationJob
  queue_as :default

  def perform(file, volume)
    v = Docker::API::Volume.new
    response = v.details(volume)

    if response.status == 200
      ToastJob.set(wait: 1.second).perform_later volume, "danger", "Volume #{volume} already exists. Choose a different name.", "Backup failed"
      return
    end

    v.create(Name: volume)

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
        Cmd: ["bash", "-c", "cd /volume && tar xvf /backup/#{file}"] }
    )
    launch_container(container_name)

    StatusCheckJob.perform_later :recovery, container_name, file, volume

  end
end