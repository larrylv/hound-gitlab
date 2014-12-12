class AddIndexToBuilds < ActiveRecord::Migration
  def change
    add_index :builds, [:merge_request_id, :commit_sha], :unique => true
  end
end
