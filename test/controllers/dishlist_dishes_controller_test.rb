require 'test_helper'

class DishlistDishesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get dishlist_dishes_create_url
    assert_response :success
  end

  test "should get destroy" do
    get dishlist_dishes_destroy_url
    assert_response :success
  end

end
