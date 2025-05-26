require "test_helper"

class NewsletterControllerTest < ActionDispatch::IntegrationTest
  test "should get email:string" do
    get newsletter_email:string_url
    assert_response :success
  end
end
