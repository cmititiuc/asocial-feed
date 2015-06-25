require 'test_helper'

class FilterTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = :webkit
    visit root_path
    @user = users(:one)
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => DEFAULT_PASSWORD
    click_button 'Log in'
  end

  teardown do
    click_link 'Sign out'
    Capybara.use_default_driver
  end

  test 'filter' do
    tag = 'rhinoceros'
    first('.edit').click

    within first('.post') do
      assert page.has_css? '.selection'
      assert page.has_css? '.select2-search__field'
      first('.select2-search__field').set tag
    end

    assert page.has_css? '.select2-results__option'
    assert first('.select2-results__option').text, tag
    
    # select tag
    first('.select2-results__option').click
    assert page.has_css? '.select2-selection__choice'

    click_button 'Update Post'
    assert page.has_no_css? '.select2-selection__choice'

    # tag is on the page now
    within first('.post') do
      assert page.has_link? tag.titleize
    end

    # new tag is in filter container
    within('#filter-container') do
      assert page.has_link? tag.titleize
      assert page.has_link? 'none'
    end

    # click some filters
    click_link 'none'
    assert page.has_no_css? '.body'

    within('#filter-container') do
      assert page.has_link? 'clear filter'
      click_link tag.titleize
    end

    assert page.has_css? '.body'

    click_link 'clear filter'

    assert page.has_css? '.body'
  end
end
