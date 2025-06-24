class TextCardJob < ApplicationJob
  queue_as :default

  def perform(phone_number, member_id)
    member_card = MemberCard.new
    member_card.text(phone_number, member_id)
  rescue Twilio::REST::RestError => e
    Rails.logger.error "Twilio Error: #{e.message}"
    raise
  rescue StandardError => e
    Rails.logger.error "Error sending text: #{e.message}"
    raise
  end
end
