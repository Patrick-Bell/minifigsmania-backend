class User < ApplicationRecord

  has_many :orders
  has_many :reviews
  has_many :product_wishlists, dependent: :destroy


  
  before_create :set_default_role
  has_secure_password


  def set_default_role
    self.role ||= 'user'
  end


  def generate_password_reset_token!
    update!(
      reset_password_token: SecureRandom.urlsafe_base64(32),
      reset_password_sent_at: Time.zone.now
    )
  end

  def password_reset_token_expired?
    puts "RESET SENT AT: #{reset_password_sent_at}"
    puts "NOW: #{Time.zone.now}"
    puts "EXPIRED?: #{reset_password_sent_at.nil? || reset_password_sent_at < 10.minutes.ago}"
    
    reset_password_sent_at.nil? || reset_password_sent_at < 10.minutes.ago
  end
  
 
end
