class Repo < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :builds

  alias_attribute :name, :full_gitlab_name

  validates :full_gitlab_name, presence: true
  validates :gitlab_id, uniqueness: true, presence: true

  def self.active
    where(active: true)
  end

  def self.find_or_create_with(attributes)
    repo = where(gitlab_id: attributes[:gitlab_id]).first_or_initialize
    repo.update_attributes(attributes)
    repo
  end

  def self.find_and_update(gitlab_id, repo_name)
    repo = find_by(gitlab_id: gitlab_id)

    if repo && repo.full_gitlab_name != repo_name
      repo.update(full_gitlab_name: repo_name)
    end

    repo
  end

  def activate
    update(active: true)
  end

  def deactivate
    update(active: false)
  end
end
