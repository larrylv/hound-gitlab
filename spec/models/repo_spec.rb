require "spec_helper"

describe Repo do
  it { should have_many(:users).through(:memberships) }
  it { should have_many :builds }
  it { should validate_presence_of :full_gitlab_name }
  it { should validate_presence_of :gitlab_id }

  it "validates uniqueness of gitlab_id" do
    create(:repo)

    expect(subject).to validate_uniqueness_of(:gitlab_id)
  end

  describe "#activate" do
    it "updates repo active value to true" do
      repo = create(:repo, active: false)

      repo.activate

      expect(repo.reload).to be_active
    end
  end

  describe "#deactivate" do
    it "updates repo active value to false" do
      repo = create(:repo, active: true)

      repo.deactivate

      expect(repo.reload).not_to be_active
    end
  end

  describe ".find_or_create_with" do
    context "with existing repo" do
      it "updates attributes" do
        repo = create(:repo)

        found_repo = Repo.find_or_create_with(gitlab_id: repo.gitlab_id)

        expect(Repo.count).to eq 1
        expect(found_repo).to eq repo
      end
    end

    context "with new repo" do
      it "creates repo with attributes" do
        attributes = build(:repo).attributes
        repo = Repo.find_or_create_with(attributes)

        expect(Repo.count).to eq 1
        expect(repo).to be_present
      end
    end
  end

  describe ".find_and_update" do
    context "when repo name doesn't match db record" do
      it "updates the record" do
        new_repo_name = "new/name"
        repo = create(:repo, name: "foo/bar")

        Repo.find_and_update(repo.gitlab_id, new_repo_name)
        repo.reload

        expect(repo.full_gitlab_name).to eq new_repo_name
      end
    end
  end
end
