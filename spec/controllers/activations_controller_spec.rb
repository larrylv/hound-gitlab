require "spec_helper"

describe ActivationsController, "#create" do
  context "when activation succeeds" do
    it "returns successful response" do
      token = "sometoken"
      membership = create(:membership)
      repo = membership.repo
      activator = double(:repo_activator, activate: true)
      allow(RepoActivator).to receive(:new).and_return(activator)
      stub_sign_in(membership.user, token)

      post :create, repo_id: repo.id, format: :json

      expect(response.code).to eq "201"
      expect(response.body).to eq RepoSerializer.new(repo).to_json
      expect(activator).to have_received(:activate)
      expect(RepoActivator).to have_received(:new).
        with(repo: repo, gitlab_token: token)
    end
  end

  context "when activation fails" do
    it "returns error response" do
      token = "sometoken"
      membership = create(:membership)
      repo = membership.repo
      activator = double(:repo_activator, activate: false).as_null_object
      allow(RepoActivator).to receive(:new).and_return(activator)
      stub_sign_in(membership.user, token)

      post :create, repo_id: repo.id, format: :json

      expect(response.code).to eq "502"
      expect(activator).to have_received(:activate)
      expect(RepoActivator).to have_received(:new).
        with(repo: repo, gitlab_token: token)
    end
  end
end
