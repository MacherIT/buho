require "application_system_test_case"

class RedsTest < ApplicationSystemTestCase
  setup do
    @red = FactoryBot.create(:red)
  end

  test "visiting the index" do
    visit reds_url
    assert_selector "h1", text: "Reds"
  end

  test "creating a Red" do
    visit reds_url
    click_on "New Red"

    fill_in "Cliente", with: @red.cliente_id
    fill_in "Nombre", with: @red.nombre
    fill_in "Nombre Display", with: @red.nombre_display
    fill_in "Tipo", with: @red.tipo
    fill_in "Token", with: @red.token
    click_on "Create Red"

    assert_text "Red was successfully created"
    click_on "Back"
  end

  test "updating a Red" do
    visit reds_url
    click_on "Edit", match: :first

    fill_in "Cliente", with: @red.cliente_id
    fill_in "Nombre", with: @red.nombre
    fill_in "Nombre Display", with: @red.nombre_display
    fill_in "Tipo", with: @red.tipo
    fill_in "Token", with: @red.token
    click_on "Update Red"

    assert_text "Red was successfully updated"
    click_on "Back"
  end

  test "destroying a Red" do
    visit reds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Red was successfully destroyed"
  end
end
