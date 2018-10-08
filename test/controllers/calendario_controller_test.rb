require 'test_helper'

class CalendarioControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendario_index_url
    assert_response :success
  end

end
