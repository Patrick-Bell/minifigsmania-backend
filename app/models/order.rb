class Order < ApplicationRecord

  has_many :line_items, dependent: :destroy

  before_validation :generate_tracking_id, on: :create
  before_validation :generate_unique_order_id, on: :create

  before_create :expected_delivery_date

  belongs_to :user, optional: true

  validates :tracking_id, uniqueness: true
  validates :order_id, uniqueness: true


  def calculate_total_price
    self.total_price = line_items.sum { |item| item.price * item.quantity } + shipping_fee
    save # Save the order after updating the total price
  end
  
  private

  def generate_tracking_id
    self.tracking_id ||= generate_unique_hex(:tracking_id)
  end


  def generate_unique_order_id
    self.order_id ||= generate_unique_hex(:order_id)
  end

  def expected_delivery_date
    self.delivery_date ||= Time.zone.now + 3.days
  end

  def generate_unique_hex(attribute)
    loop do
      token = 'TRK-' + SecureRandom.hex(10).upcase
      #token = SecureRandom.hex(20)
      break token unless Order.exists?(attribute => token)
    end
  end
end
