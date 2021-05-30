class NotificationChannel < ApplicationCable::Channel
  def subscribed
     stream_from "global_notification"
  end

  def unsubscribed
  end

  def complete
  end
end
