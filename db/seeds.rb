product1 = Product.find_by(name: 'Bellingham')
product2 = Product.find_by(name: 'Van Dijk - Liverpool')
product3 = Product.find_by(name: 'Sonic The Hedgehog')
product4 = Product.find_by(name: 'Saka')

# Ensure products exist
raise "Product 'Sonic The Hedgehog' not found" unless product1
raise "Product 'Haaland - Man City' not found" unless product2



# Create the order
order = Order.create!(
  name: "Patrick",
  email: "patrickbell1302@gmail.com",
  phone: "123-456-7890",
  address: "123 Main St, New York, NY",
  status: "processing",
  shipping_fee: 4.99,
  payment_method: "card",
  date: Time.now,
  delivery_date: Time.now + 5.days,
  paid: true,
  platform: "web",
  order_id: SecureRandom.hex(6),
  tracking_id: SecureRandom.hex(12),
  user_id: 10
)

# Add line items to the order
LineItem.create!(
  name: "Bellingham",
  price: 3.99,
  quantity: 2,
  image: 'https://res.cloudinary.com/duzlv0fex/image/upload/v1744120647/peo0hah1vwa9mvyiuhsu.webp',
  order_id: order.id,
  product_id: product1.id
)

LineItem.create!(
  name: 'Van Dijk - Liverpool',
  price: 4.99,
  quantity: 1,
  image: 'https://res.cloudinary.com/duzlv0fex/image/upload/v1743428872/erkd0dckyichqp2f6oxe.webp',
  order_id: order.id,
  product_id: product2.id
)

LineItem.create!(
  name: 'Sonic The Hedgehog',
  price: 4.99,
  quantity: 1,
  image: 'https://res.cloudinary.com/duzlv0fex/image/upload/v1743429578/cylv8s5vyxbhoi0vfjap.webp',
  order_id: order.id,
  product_id: product3.id
)

LineItem.create!(
  name: 'Saka',
  price: 3.99,
  quantity: 2,
  image: 'https://res.cloudinary.com/duzlv0fex/image/upload/v1744233159/wbxho42myktyppyittxj.webp',
  order_id: order.id,
  product_id: product4.id
)

order.calculate_total_price

puts order.line_items.inspect

OrderMailer.new_order(order).deliver_now
OrderMailer.new_order_admin(order).deliver_now