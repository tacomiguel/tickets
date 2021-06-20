require "application_system_test_case"

class TicketStatusesTest < ApplicationSystemTestCase
  setup do
    @ticket_status = ticket_statuses(:one)
  end

  test "visiting the index" do
    visit ticket_statuses_url
    assert_selector "h1", text: "Ticket Statuses"
  end

  test "creating a Ticket status" do
    visit ticket_statuses_url
    click_on "New Ticket Status"

    fill_in "Name", with: @ticket_status.name
    fill_in "Sort", with: @ticket_status.sort
    click_on "Create Ticket status"

    assert_text "Ticket status was successfully created"
    click_on "Back"
  end

  test "updating a Ticket status" do
    visit ticket_statuses_url
    click_on "Edit", match: :first

    fill_in "Name", with: @ticket_status.name
    fill_in "Sort", with: @ticket_status.sort
    click_on "Update Ticket status"

    assert_text "Ticket status was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket status" do
    visit ticket_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket status was successfully destroyed"
  end
end
