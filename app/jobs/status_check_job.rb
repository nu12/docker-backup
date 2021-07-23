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
      Task.remove_backup volume
      IconJob.perform_now volume, ''
    else
      Task.remove_restore file
      IconJob.perform_now file, ''
    end

  end
end
