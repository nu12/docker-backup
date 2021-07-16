class StatusCheckJob < ApplicationJob
  queue_as :default

  def perform(task, container_name, file, volume)
    c = Docker::API::Container.new
    response = c.details(container_name)

    if response.status == 200 # Container still exists, check again alter
      StatusCheckJob.set(wait: 1.second).perform_later task, container_name, file, volume
      return
    end

    id = task == :backup ? volume : file
    
    IconJob.perform_now id, '<i class="fas fa-check"></i>'
  end
end
