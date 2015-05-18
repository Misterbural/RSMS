require 'test_helper'

class ScheduledsControllerTest < ActionController::TestCase
  setup do
    @scheduled = scheduleds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scheduleds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scheduled" do
    assert_difference('Scheduled.count') do
      post :create, scheduled: { content: @scheduled.content, progress: @scheduled.progress, send_at: @scheduled.send_at }
    end

    assert_redirected_to scheduled_path(assigns(:scheduled))
  end

  test "should show scheduled" do
    get :show, id: @scheduled
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scheduled
    assert_response :success
  end

  test "should update scheduled" do
    patch :update, id: @scheduled, scheduled: { content: @scheduled.content, progress: @scheduled.progress, send_at: @scheduled.send_at }
    assert_redirected_to scheduled_path(assigns(:scheduled))
  end

  test "should destroy scheduled" do
    assert_difference('Scheduled.count', -1) do
      delete :destroy, id: @scheduled
    end

    assert_redirected_to scheduleds_path
  end
end
