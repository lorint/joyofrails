class HeartbeatChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_admin_user
  end

  def unsubscribed
  end
end
