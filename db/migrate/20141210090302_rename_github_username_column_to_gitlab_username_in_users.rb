class RenameGithubUsernameColumnToGitlabUsernameInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :github_username, :gitlab_username
  end
end
