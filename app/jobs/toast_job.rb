class ToastJob < ApplicationJob
  queue_as :default

  def perform(id, color, message, title = "Notification")
    ActionCable.server.broadcast("global_notification", {id:id, html: render_partial(id, color, message, title)})
  end

  private

  def render_partial(id, color, message, title)
    ApplicationController.renderer.render partial: "layouts/toast", locals: {id:id, color: color, message: message, title: title}
  end
end
