require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = FactoryBot.create(:post)
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "creating a Post" do
    visit posts_url
    click_on "New Post"

    fill_in "Hora Pub", with: @post.hora_pub
    fill_in "Publicado", with: @post.publicado
    fill_in "Red", with: @post.red_id
    fill_in "Texto", with: @post.texto
    fill_in "Titulo", with: @post.titulo
    click_on "Create Post"

    assert_text "Post was successfully created"
    click_on "Back"
  end

  test "updating a Post" do
    visit posts_url
    click_on "Edit", match: :first

    fill_in "Hora Pub", with: @post.hora_pub
    fill_in "Publicado", with: @post.publicado
    fill_in "Red", with: @post.red_id
    fill_in "Texto", with: @post.texto
    fill_in "Titulo", with: @post.titulo
    click_on "Update Post"

    assert_text "Post was successfully updated"
    click_on "Back"
  end

  test "destroying a Post" do
    visit posts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post was successfully destroyed"
  end
end
