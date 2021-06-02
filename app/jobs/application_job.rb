class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  private
  def pull_image(image)
      i = Docker::API::Image.new
      i.create( fromImage: image )
  end

  def launch_container(container)
      c = Docker::API::Container.new
      c.start(container)
  end

  def generate_name()
    return (0...8).map { (65 + rand(26)).chr }.join
  end
end
