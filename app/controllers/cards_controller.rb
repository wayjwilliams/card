class CardsController < ApplicationController
  def index
  end

  # include MemberId

  # def text_card
  #   params.require(:send_number)
  #   member_id = MemberId.new()
  #   unless Rails.env.development?
  #     if verify_recaptcha secret_key: .captcha_secret_key
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
  #     if verify_recaptcha secret_key: .captcha_secret_key
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
