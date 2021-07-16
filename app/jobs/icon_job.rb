class IconJob < ApplicationJob
  queue_as :default

  def perform(id, icon)
    ActionCable.server.broadcast("global_notification", {id:id, icon: icon})
  end

end
