require 'spec_helper'

feature 'User authentication' do
  scenario "existing user signs in" do
    token = "usergitlabtoken"
    user = create(:user)
    stub_repo_requests(token)

    sign_in_as(user)

    expect(page).to have_content user.gitlab_username
  end

  scenario "new user signs in" do
    token = "usergitlabtoken"
    gitlab_username = "croaky"
    user = build(:user, gitlab_username: gitlab_username)
    stub_repo_requests(token)

    sign_in_as(user, token)

    expect(page).to have_content(gitlab_username)
  end

  scenario 'user signs out' do
    token = "usergitlabtoken"
    user = create(:user)
    stub_repo_requests(token)

    sign_in_as(user, token)
    find('a[href="/sign_out"]').click

    expect(page).not_to have_content user.gitlab_username
  end
end
