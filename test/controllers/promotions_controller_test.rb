require "test_helper"

class PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @promotion = promotions(:one)
  end

  test "should get index" do
    get promotions_url, as: :json
    assert_response :success
  end

  test "should create promotion" do
    assert_difference("Promotion.count") do
      post promotions_url, params: { promotion: { active: @promotion.active, code: @promotion.code, coupon_id: @promotion.coupon_id, duration: @promotion.duration, expires_at: @promotion.expires_at, percent_off: @promotion.percent_off, redeemed_count: @promotion.redeemed_count, usage_limit: @promotion.usage_limit, user_id: @promotion.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show promotion" do
    get promotion_url(@promotion), as: :json
    assert_response :success
  end

  test "should update promotion" do
    patch promotion_url(@promotion), params: { promotion: { active: @promotion.active, code: @promotion.code, coupon_id: @promotion.coupon_id, duration: @promotion.duration, expires_at: @promotion.expires_at, percent_off: @promotion.percent_off, redeemed_count: @promotion.redeemed_count, usage_limit: @promotion.usage_limit, user_id: @promotion.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy promotion" do
    assert_difference("Promotion.count", -1) do
      delete promotion_url(@promotion), as: :json
    end

    assert_response :no_content
  end
end
