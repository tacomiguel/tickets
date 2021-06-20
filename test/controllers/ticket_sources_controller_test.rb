require 'test_helper'

class TicketSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_source = ticket_sources(:one)
  end

  test "should get index" do
    get ticket_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_source_url
    assert_response :success
  end

  test "should create ticket_source" do
    assert_difference('TicketSource.count') do
      post ticket_sources_url, params: { ticket_source: { name: @ticket_source.name } }
    end

    assert_redirected_to ticket_source_url(TicketSource.last)
  end

  test "should show ticket_source" do
    get ticket_source_url(@ticket_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_source_url(@ticket_source)
    assert_response :success
  end

  test "should update ticket_source" do
    patch ticket_source_url(@ticket_source), params: { ticket_source: { name: @ticket_source.name } }
    assert_redirected_to ticket_source_url(@ticket_source)
  end

  test "should destroy ticket_source" do
    assert_difference('TicketSource.count', -1) do
      delete ticket_source_url(@ticket_source)
    end

    assert_redirected_to ticket_sources_url
  end
end
