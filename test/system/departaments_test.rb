require "application_system_test_case"

class DepartamentsTest < ApplicationSystemTestCase
  setup do
    @departament = departaments(:one)
  end

  test "visiting the index" do
    visit departaments_url
    assert_selector "h1", text: "Departaments"
  end

  test "creating a Departament" do
    visit departaments_url
    click_on "New Departament"

    fill_in "Name", with: @departament.name
    click_on "Create Departament"

    assert_text "Departament was successfully created"
    click_on "Back"
  end

  test "updating a Departament" do
    visit departaments_url
    click_on "Edit", match: :first

    fill_in "Name", with: @departament.name
    click_on "Update Departament"

    assert_text "Departament was successfully updated"
    click_on "Back"
  end

  test "destroying a Departament" do
    visit departaments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Departament was successfully destroyed"
  end
end
