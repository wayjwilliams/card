class MemberCard < ApplicationRecord
  require "mini_magick"

   def self.generate_coupon(member)
    base_url = ENV["CARD_BASE_URL"] || "https://state-plan.unacdn.com/state_plan_images/state-card-backgrounds/test/card.png"
    image = MiniMagick::Image.open(base_url)

    # Overlay the member ID text
    image.combine_options do |c|
      c.gravity "center"         # Try "center", "north", "south", etc.
      c.font "Liberation-Sans"
      c.fill "black"
      c.pointsize "70"
      c.draw "text 0,350 '#{member}'"  # Adjust coordinates as needed
    end

    image
  end

  def create_image_file(coupon_image, member)
    processed_image = MiniMagick::Image.open(coupon_image.to_s)
    processed_image.contrast
    processed_image.write("app/assets/images/card.png")
    processed_image
  end

  def text(to_number, member_id)
    image_url = ENV["CARD_BASE_URL"] || "https://state-plan.unacdn.com/state_plan_images/state-card-backgrounds/test/card.png"

    @client = Twilio::REST::Client.new(
      ENV["TWILIO_ACCOUNT_SID"],
      ENV["TWILIO_AUTH_TOKEN"]
    )

    message = @client.messages.create(
      to: "+1#{to_number}",
      from: ENV["STATE_TWILIO_NUMBER"],
      body: "ID Number: 8UH6PJAPV5\n\nYou may opt out of receiving texts by replying STOP",
      media_url: image_url
    )
    Rails.logger.info "Twilio message sent! SID: #{message.sid}"

    rescue => e
      Rails.logger.error "Text Message Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end

  def email(customer_email)
    return if customer_email.blank? # Prevent sending if blank

    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    message_params = {
      from: "No Reply <noreply@sandbox7b822cd9b5ae46d58e8a23622b2776aa.mailgun.org>",
      to: customer_email.to_s, # Make sure this is not nil or blank
      subject: "Your fake membership card to nowhere is here!",
      text: "here's your card!",
      attachment: ENV["SEND_CARD_URL"]
    }
    mg_client.send_message(ENV["MAILGUN_DOMAIN"], message_params)
  end
end
