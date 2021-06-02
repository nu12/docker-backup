class ToastJob < ApplicationJob
  queue_as :default

  def perform(color, message, title = "Notification")
    ActionCable.server.broadcast("global_notification", render_partial(color, message, title))
  end

  private

  def render_partial(color, message, title)
    ApplicationController.renderer.render partial: "layouts/toast", locals: {color: color, message: message, title: title}
  end
end
