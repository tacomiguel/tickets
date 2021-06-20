require 'test_helper'

class TicketThreadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_thread = ticket_threads(:one)
  end

  test "should get index" do
    get ticket_threads_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_thread_url
    assert_response :success
  end

  test "should create ticket_thread" do
    assert_difference('TicketThread.count') do
      post ticket_threads_url, params: { ticket_thread: {  } }
    end

    assert_redirected_to ticket_thread_url(TicketThread.last)
  end

  test "should show ticket_thread" do
    get ticket_thread_url(@ticket_thread)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_thread_url(@ticket_thread)
    assert_response :success
  end

  test "should update ticket_thread" do
    patch ticket_thread_url(@ticket_thread), params: { ticket_thread: {  } }
    assert_redirected_to ticket_thread_url(@ticket_thread)
  end

  test "should destroy ticket_thread" do
    assert_difference('TicketThread.count', -1) do
      delete ticket_thread_url(@ticket_thread)
    end

    assert_redirected_to ticket_threads_url
  end
end
