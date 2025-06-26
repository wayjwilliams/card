class EmailCouponJob < ApplicationJob
  queue_as :coupon_email

  def perform(customer_email)
    MemberCard.new().email(customer_email)
  end
end
