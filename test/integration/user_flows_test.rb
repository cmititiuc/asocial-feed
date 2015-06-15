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

# create a post
# edit a post
# destroy a post
# edit link changes to cancel link
# cancel link changes to edit link
  # on cancel
  # on update
# same day date transfered on destroy
# form injected on edit
# correct text on injected form
# test sign up
# test log in as a guest
# test formatting help
# topic changes to none after create if no filter is set
# topic changes to filter when filter is set
# topic stays when post created while filter is set
# post created with topic not matching filter is not displayed
# post created matching filter is displayed
