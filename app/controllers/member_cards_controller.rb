class MemberCardsController < ApplicationController
  include MemberId

  def index
    member_id = MemberId.new
    @member_id = member_id.to_s
    image = MemberCard.generate_coupon(@member_id)
    @card_image_data = "data:image/png;base64,#{Base64.strict_encode64(image.to_blob)}"
  end

  def create_card
    begin
      if params[:member_id].present?
        @member_id = sanitize_input(params[:member_id])
      else
        @member_id = MemberId.new()
      end

      Rails.logger.info("member_id: #{@member_id}")

      respond_to do |format|
        format.png do
          begin
            image_data = Card.generate_coupon(@member_id).to_blob
            send_data image_data, type: "image/png", disposition: "inline"
          rescue => image_error
            Rails.logger.error "Image generation failed: #{image_error.message}"

            # Temporary workaround: redirect to static background image
            # Remove this once ImageMagick is properly configured
            static_image_url = ENV["CARD_BASE_URL"]
            redirect_to static_image_url, status: :moved_permanently, allow_other_host: true
          end
        end
      end
    rescue StandardError => e
      Rails.logger.error("Card generation failed - IP: #{request.remote_ip}, error: #{e.message}, member_id: #{params[:member_id]}")

      # Fallback to static image for any errors
      static_image_url = ENV["CARD_BASE_URL"]
      Rails.logger.info("Redirecting to static image URL: #{static_image_url}")

      respond_to do |format|
        format.png { redirect_to static_image_url, status: :moved_permanently, allow_other_host: true }
        format.json { render json: { error: "Unable to generate card", static_url: static_image_url }, status: :internal_server_error }
      end
    end
  end




  #  def text_card
  #   params.require(:send_number)
  #   member_id = MemberId.new()
  #   unless Rails.env.development?
  #     if verify_recaptcha secret_key: @state_plan.captcha_secret_key
  #       TextCouponJob.perform_later(params[:send_number], @state_plan.id, member_id.to_s)
  #       redirect_back fallback_location: root_url, notice: "Your free drug coupon was sent via SMS to the number you provided. Thanks!"
  #     else
  #       redirect_back fallback_location: root_url, alert: "Please confirm that you aren't a robot!"
  #     end
  #   else
  #     TextCouponJob.perform_later(params[:send_number], @state_plan.id, member_id.to_s)
  #     redirect_back fallback_location: root_url, notice: "Your free drug coupon was sent via SMS to the number you provided. Thanks!"
  #   end
  # end

  # def email_card
  #   params.require(:email)
  #   member_id = MemberId.new()
  #   unless Rails.env.development?
  #     if verify_recaptcha secret_key: @state_plan.captcha_secret_key
  #       customer_email = params[:email]
  #       member = MemberId.new()
  #       EmailCouponJob.perform_later(customer_email, member.to_s, @state_plan.id)
  #       redirect_back fallback_location: root_url, notice: "Your free drug coupon was successfully emailed to the address you provided. Please check your inbox (or spam folder). Thanks!"
  #     else
  #       redirect_back fallback_location: root_url, alert: "Please confirm that you aren't a robot!"
  #     end
  #   else
  #     EmailCouponJob.perform_later(customer_email, member.to_s, @state_plan.id)
  #     redirect_back fallback_location: root_url, notice: "Your free drug coupon was sent via SMS to the number you provided. Thanks!"
  #   end
  # end
end
