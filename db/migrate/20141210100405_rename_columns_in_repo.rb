class RenameColumnsInRepo < ActiveRecord::Migration
  def change
    rename_column :repos, :github_id, :gitlab_id
    rename_column :repos, :full_github_name, :full_gitlab_name
    remove_column :repos, :in_organization
  end
end
