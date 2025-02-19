require "rails_helper"

RSpec.describe "/pwa/web_pushes", type: :request do
  describe "POST" do
    before do
      allow(WebPush).to receive(:payload_send)
    end

    it "creates a new web push subscription" do
      title = "Hello"
      message = "World"
      subscription = {
        endpoint: "https://fcm.googleapis.com/fcm/send/KEY",
        keys: {
          p256dh: SecureRandom.base64(16),
          auth: SecureRandom.base64(8)
        }
      }

      post pwa_web_pushes_path, params: {web_push: {title:, message:, subscription: subscription.to_json}}
      perform_enqueued_jobs

      message_json = {
        title: title,
        body: message,
        icon: ActionController::Base.helpers.asset_url("app-icons/icon-192.png")
      }.to_json
      expect(WebPush).to have_received(:payload_send).with(hash_including(
        message: message_json,
        endpoint: subscription[:endpoint],
        p256dh: subscription.dig(:keys, :p256dh),
        auth: subscription.dig(:keys, :auth),
        vapid: {
          subject: Rails.configuration.x.vapid.subject,
          public_key: Rails.configuration.x.vapid.public_key,
          private_key: Rails.configuration.x.vapid.private_key
        }
      ))
    end
  end
end
