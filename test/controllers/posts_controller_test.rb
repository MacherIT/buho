require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = FactoryBot.create(:post)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { hora_pub: @post.hora_pub, publicado: @post.publicado, red_id: @post.red_id, texto: @post.texto, titulo: @post.titulo } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { hora_pub: @post.hora_pub, publicado: @post.publicado, red_id: @post.red_id, texto: @post.texto, titulo: @post.titulo } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
