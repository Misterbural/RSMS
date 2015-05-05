require 'test_helper'

class ReceivedsControllerTest < ActionController::TestCase
  setup do
    @received = receiveds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receiveds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create received" do
    assert_difference('Received.count') do
      post :create, received: { content: @received.content, is_command: @received.is_command, send_by: @received.send_by }
    end

    assert_redirected_to received_path(assigns(:received))
  end

  test "should show received" do
    get :show, id: @received
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @received
    assert_response :success
  end

  test "should update received" do
    patch :update, id: @received, received: { content: @received.content, is_command: @received.is_command, send_by: @received.send_by }
    assert_redirected_to received_path(assigns(:received))
  end

  test "should destroy received" do
    assert_difference('Received.count', -1) do
      delete :destroy, id: @received
    end

    assert_redirected_to receiveds_path
  end
end
