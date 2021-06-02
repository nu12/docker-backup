class StatusCheckJob < ApplicationJob
  queue_as :default

  def perform(task, container_name, file, volume)
    c = Docker::API::Container.new
    response = c.details(container_name)

    if response.status == 200 # Container still exists, check again alter
      StatusCheckJob.set(wait: 1.second).perform_later task, container_name, file, volume
      return
    end
    
    if task == :backup
      ToastJob.perform_now "success", "Backup for #{volume} is completed.", "Backup completed"
      return
    end
    
    ToastJob.perform_now "success", "New volume #{volume} created from file #{file}.", "Recovery completed"
  end
end
