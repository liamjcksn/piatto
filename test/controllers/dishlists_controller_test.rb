require 'test_helper'

class DishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dishlists_index_url
    assert_response :success
  end

  test "should get show" do
    get dishlists_show_url
    assert_response :success
  end

  test "should get create" do
    get dishlists_create_url
    assert_response :success
  end

  test "should get update" do
    get dishlists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get dishlists_destroy_url
    assert_response :success
  end

end
