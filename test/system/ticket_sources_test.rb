require "application_system_test_case"

class TicketSourcesTest < ApplicationSystemTestCase
  setup do
    @ticket_source = ticket_sources(:one)
  end

  test "visiting the index" do
    visit ticket_sources_url
    assert_selector "h1", text: "Ticket Sources"
  end

  test "creating a Ticket source" do
    visit ticket_sources_url
    click_on "New Ticket Source"

    fill_in "Name", with: @ticket_source.name
    click_on "Create Ticket source"

    assert_text "Ticket source was successfully created"
    click_on "Back"
  end

  test "updating a Ticket source" do
    visit ticket_sources_url
    click_on "Edit", match: :first

    fill_in "Name", with: @ticket_source.name
    click_on "Update Ticket source"

    assert_text "Ticket source was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket source" do
    visit ticket_sources_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket source was successfully destroyed"
  end
end
