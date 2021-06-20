require "application_system_test_case"

class TicketThreadsTest < ApplicationSystemTestCase
  setup do
    @ticket_thread = ticket_threads(:one)
  end

  test "visiting the index" do
    visit ticket_threads_url
    assert_selector "h1", text: "Ticket Threads"
  end

  test "creating a Ticket thread" do
    visit ticket_threads_url
    click_on "New Ticket Thread"

    click_on "Create Ticket thread"

    assert_text "Ticket thread was successfully created"
    click_on "Back"
  end

  test "updating a Ticket thread" do
    visit ticket_threads_url
    click_on "Edit", match: :first

    click_on "Update Ticket thread"

    assert_text "Ticket thread was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket thread" do
    visit ticket_threads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket thread was successfully destroyed"
  end
end
