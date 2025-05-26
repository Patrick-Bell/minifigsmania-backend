class HomeController < ApplicationController
  skip_before_action :set_current_user

  def index
    render file: Rails.root.join('public', 'index.html'), layout: false
  end
end
