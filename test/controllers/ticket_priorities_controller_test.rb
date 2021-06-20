require 'test_helper'

class TicketPrioritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_priority = ticket_priorities(:one)
  end

  test "should get index" do
    get ticket_priorities_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_priority_url
    assert_response :success
  end

  test "should create ticket_priority" do
    assert_difference('TicketPriority.count') do
      post ticket_priorities_url, params: { ticket_priority: { color: @ticket_priority.color, level: @ticket_priority.level, name: @ticket_priority.name } }
    end

    assert_redirected_to ticket_priority_url(TicketPriority.last)
  end

  test "should show ticket_priority" do
    get ticket_priority_url(@ticket_priority)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_priority_url(@ticket_priority)
    assert_response :success
  end

  test "should update ticket_priority" do
    patch ticket_priority_url(@ticket_priority), params: { ticket_priority: { color: @ticket_priority.color, level: @ticket_priority.level, name: @ticket_priority.name } }
    assert_redirected_to ticket_priority_url(@ticket_priority)
  end

  test "should destroy ticket_priority" do
    assert_difference('TicketPriority.count', -1) do
      delete ticket_priority_url(@ticket_priority)
    end

    assert_redirected_to ticket_priorities_url
  end
end
