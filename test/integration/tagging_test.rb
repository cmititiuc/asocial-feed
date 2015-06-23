require 'test_helper'

class TaggingTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit
    visit root_path
    @user = users(:two)
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => DEFAULT_PASSWORD
    click_button 'Log in'
  end

  teardown do
    click_link 'Sign out'
    Capybara.use_default_driver
  end

  test "has tagging field" do
    assert page.has_css? '#post_tag_list'
  end

  test "create a post with a tag" do
    tag = 'testtag2'
    assert page.has_css? '.selection'
    assert page.has_css? '.select2-search__field'
    
    # input text in search field
    first('.select2-search__field').set tag
    assert page.has_css? '.select2-results__option'
    assert first('.select2-results__option').text, tag
    
    # select tag
    first('.select2-results__option').click
    assert page.has_css? '.select2-selection__choice'
    fill_in 'post_body', :with => 'test post'

    click_button 'Create Post'
    assert page.has_no_css? '.select2-selection__choice'

    # tag is on the page now
    assert page.has_content? tag
    assert page.has_css? '.post'
  end

  test "edit a posts tag" do
    tag = 'testtag3'
    assert page.has_content? @user.email
    assert page.has_content? 'Post 2'
    assert page.has_content? 'testtag1'
    assert page.has_css? '.post'

    first('.edit').click

    within first('.post') do
      assert page.has_css? '.selection'
      assert page.has_css? '.select2-search__field'
      first('.select2-search__field').set tag
    end

    assert first('.select2-results__option').text, tag
    assert page.has_css? '.select2-results__option'

    first('.select2-results__option').click
    assert page.has_css? '.select2-selection__choice'
    click_button 'Update Post'

    assert page.has_content?('Post was successfully updated.')
    within first('.post') do
      assert page.has_content? tag
    end
  end
end
