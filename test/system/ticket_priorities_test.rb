require "application_system_test_case"

class TicketPrioritiesTest < ApplicationSystemTestCase
  setup do
    @ticket_priority = ticket_priorities(:one)
  end

  test "visiting the index" do
    visit ticket_priorities_url
    assert_selector "h1", text: "Ticket Priorities"
  end

  test "creating a Ticket priority" do
    visit ticket_priorities_url
    click_on "New Ticket Priority"

    fill_in "Color", with: @ticket_priority.color
    fill_in "Level", with: @ticket_priority.level
    fill_in "Name", with: @ticket_priority.name
    click_on "Create Ticket priority"

    assert_text "Ticket priority was successfully created"
    click_on "Back"
  end

  test "updating a Ticket priority" do
    visit ticket_priorities_url
    click_on "Edit", match: :first

    fill_in "Color", with: @ticket_priority.color
    fill_in "Level", with: @ticket_priority.level
    fill_in "Name", with: @ticket_priority.name
    click_on "Update Ticket priority"

    assert_text "Ticket priority was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket priority" do
    visit ticket_priorities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket priority was successfully destroyed"
  end
end
