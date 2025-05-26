 Rails.application.config.middleware.insert_before 0, Rack::Cors do
   allow do
     origins "http://localhost:5173"

     resource "*",
       headers: :any,
       methods: [:get, :post, :put, :patch, :delete, :options, :head],
       credentials: true
   end

   allow do
    origins 'https://683475bff4b6fd008427b749--minifigsmania.netlify.app'  # <-- your Netlify frontend URL here

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
