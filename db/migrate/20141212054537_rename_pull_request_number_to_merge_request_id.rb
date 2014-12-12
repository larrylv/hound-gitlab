class RenamePullRequestNumberToMergeRequestId < ActiveRecord::Migration
  def change
    rename_column :builds, :pull_request_number, :merge_request_id
  end
end
