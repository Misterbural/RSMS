require 'test_helper'

class SendedsControllerTest < ActionController::TestCase
  setup do
    @sended = sendeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sendeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sended" do
    assert_difference('Sended.count') do
      post :create, sended: { content: @sended.content, target: @sended.target }
    end

    assert_redirected_to sended_path(assigns(:sended))
  end

  test "should show sended" do
    get :show, id: @sended
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sended
    assert_response :success
  end

  test "should update sended" do
    patch :update, id: @sended, sended: { content: @sended.content, target: @sended.target }
    assert_redirected_to sended_path(assigns(:sended))
  end

  test "should destroy sended" do
    assert_difference('Sended.count', -1) do
      delete :destroy, id: @sended
    end

    assert_redirected_to sendeds_path
  end
end
