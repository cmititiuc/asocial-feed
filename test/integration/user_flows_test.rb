require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  test "login" do
    session = login(users(:one))
    assert_equal session.flash[:notice], 'Signed in successfully.'
    assert_equal '/', session.path
    # session.assert_select '#add-new-topic', 'Add new topic'
  end

  private
 
    # module CustomDsl
    #   def browses_site
    #     get "/posts"
    #     assert_response :success
    #     assert assigns(:posts)
    #   end
    # end
 
    def login(user)
      open_session do |sess|
        # sess.extend(CustomDsl)
        sess.https!
        sess.post_via_redirect "/users/sign_in", :user => { email: user.email, password: DEFAULT_PASSWORD }
        assert_equal '/', sess.path
        sess.https!(false)
      end
    end
end
