class TextCardJob < ApplicationJob
  queue_as :default

  def perform(to_number, member_id)
    MemberCard.new().text(to_number, member_id)
  end
end
