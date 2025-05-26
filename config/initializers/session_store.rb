
# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, 
                                       key: 'jwt_token', 
                                       expire_after: 1.day, 
                                       httponly: true, 
                                       secure: Rails.env.production?
