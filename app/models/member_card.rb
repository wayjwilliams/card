class MemberCard < ApplicationRecord
  require "mini_magick"

   def self.generate_coupon(member)
    base_url = ENV["CARD_BASE_URL"] || "https://state-plan.unacdn.com/state_plan_images/state-card-backgrounds/test/card.png"
    image = MiniMagick::Image.open(base_url)

    # Overlay the member ID text
    image.combine_options do |c|
      c.gravity "center"         # Try "center", "north", "south", etc.
      c.font "Arial"
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
    @client = Twilio::REST::Client.new(
      ENV["TWILLIO_ACCOUNT_SID"],
      ENV["TWILLIO_AUTH_TOKEN"]
    )
    account_sid = Rails.application.credentials.twilio.account_sid
    auth_token = Rails.application.credentials.twilio.auth_token
    @client = Twilio::REST::Client.new(account_sid, auth_token)
      # begin
      message = @client.messages.create(
        to: "+1#{to_number}",  # Text this number
        from: Rails.application.credentials.twilio.send_number, # From a valid Twilio number
        body: "ID Number: #{member_id}\n\nYou may opt out of receiving texts by replying STOP",
        media_url: @card_image_data
      )
  end
end

# def email(customer_email, member)
#   if Rails.env.development?
#     coupon_image = "http://localhost:3000/state-coupon.png?member_id=#{member}"
#   else
#     coupon_image = "https://state-coupon.png?member_id=#{member}"
#   end
#   processed_image = create_image_file(coupon_image, member)

#   # First, instantiate the Mailgun Client with your API key
#
#   # Define your message parameters
#   message_params = {
#     from: "No Reply <no-reply@.com>",
#     to: customer_email.to_s,
#     subject: "Your fake membership card to nowhere is here!",
#     html: "<html>
#             <head>
#               <style>
#                 body {
#                   color: #488499;
#                 }
#                 .member-info {
#                   color: #D5722D;
#                 }
#                 .dashed {
#                   border: 1px dashed black;
#                 }
#               </style>
#             </head>
#             <body>
#               <h3>Here is your FREE Pharmacy Rx Coupon/Card compliments o</h3>
#               <p>(1) Take this coupon/card into any participating pharmacy.</p>
#               <p>(2) Present this coupon/card. </p>
#               <p>(3) Save $ on your prescriptions</p>
#               <hr class='dashed'/>
#               <hr class='dashed'/>
#               <h1>Pharmacy Rx Prescription Drug Coupon/Card</h1>
#               <hr class='dashed'/>
#               <hr class='dashed'/>
#               <h1 class='member-info'>ID Number: #{member}</h1>
#               <hr class='dashed'/>
#               <hr class='dashed'/>
#               <p>Customer Service: 877-321-6755</p>
#               <p>Pharmacy Helpline: 800-223-2146</p>
#               <p>Participatign Pharmacies include: Walgreens, CVS, Walmart, Rite Aid, Target, Safeway, Albertsons/Sav-on, and many others</p>
#               <p>You can also print attached card</p>
#               <br/>
#               <p><small><i>This is not a Medicare prescription drug plan. Program is privately supported.</i></small></p>
#               <p><small><i>This is not a government run/affiliated/funded program.</i></small></p>
#               <p><small><i>Discounts are only available at participating pharmacies.</i></small></p>
#               <p><small><i>This program/ is a drug coupon. THIS IS NOT INSURANCE.</i></small></p>
#             </body>
#           </html>",
#     attachment: File.open("app/assets/images/discount-card-#{member}.png")
#   }

#   # Send your message through the client
#   mg_client.send_message "mg.unacdn.com", message_params

#   # make this match the create line
#   File.delete("app/assets/images/discount-card-#{member}.png")
# end
