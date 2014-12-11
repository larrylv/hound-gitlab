require 'spec_helper'

describe RepoActivator do
  describe '#activate' do
    context 'when repo activation succeeds' do
      it 'activates repo' do
        token = "gitlabtoken"
        repo = create(:repo)
        stub_gitlab_api
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        result = activator.activate

        expect(result).to be_truthy
        expect(repo.reload).to be_active
      end

      it 'makes Hound a collaborator' do
        repo = create(:repo)
        gitlab = stub_gitlab_api
        token = "gitlabtoken"
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        activator.activate

        expect(gitlab).to have_received(:add_team_member)
      end

      it 'returns true if the repo activates successfully' do
        repo = create(:repo)
        stub_gitlab_api
        token = "gitlabtoken"
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        result = activator.activate

        expect(result).to be_truthy
      end

      context 'when https is enabled' do
        it 'creates gitlab hook using secure build URL' do
          with_https_enabled do
            repo = create(:repo)
            token = "gitlabtoken"
            gitlab = stub_gitlab_api
            activator = RepoActivator.new(gitlab_token: token, repo: repo)

            activator.activate

            expect(gitlab).to have_received(:add_project_hook).with(
              repo.gitlab_id,
              URI.join("https://#{ENV['HOST']}", 'builds').to_s,
              RepoActivator::HOOK_OPTIONS
            )
          end
        end
      end

      context 'when https is disabled' do
        it 'creates gitlab hook using insecure build URL' do
          repo = create(:repo)
          gitlab = stub_gitlab_api
          token = "gitlabtoken"
          activator = RepoActivator.new(gitlab_token: token, repo: repo)

          activator.activate

          expect(gitlab).to have_received(:add_project_hook).with(
            repo.gitlab_id,
            URI.join("http://#{ENV['HOST']}", 'builds').to_s,
            RepoActivator::HOOK_OPTIONS
          )
        end
      end
    end

    context 'when repo activation fails' do
      it 'returns false if API request raises' do
        token = nil
        repo = build_stubbed(:repo)
        expect(Gitlab).to receive(:client).and_raise(Gitlab::Error::BadRequest.new)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        result = activator.activate

        expect(result).to be_falsy
      end

      it 'only swallows Gitlab errors' do
        token = "gitlabtoken"
        repo = double('repo')
        allow(Gitlab).to receive(:client).and_raise(Exception.new)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        expect { activator.activate }.to raise_error(Exception)
      end

      context 'when Hound cannot be added to repo' do
        it 'returns false' do
          token = "gitlabtoken"
          repo = build_stubbed(:repo, full_gitlab_name: "test/repo")
          gitlab = double(:gitlab, add_team_member: false)
          allow(Gitlab).to receive(:client).and_return(gitlab)
          activator = RepoActivator.new(gitlab_token: token, repo: repo)

          result = activator.activate

          expect(result).to be_falsy
        end
      end
    end

    context 'hook already exists' do
      it 'does not raise' do
        token = 'token'
        repo = build_stubbed(:repo)
        gitlab = double(:gitlab, add_project_hook: nil, add_team_member: true)
        allow(Gitlab).to receive(:client).and_return(gitlab)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        expect do
          activator.activate
        end.not_to raise_error
      end
    end
  end

  describe '#deactivate' do
    context 'when repo activation succeeds' do
      it 'deactivates repo' do
        stub_gitlab_api
        token = "gitlabtoken"
        repo = create(:repo)
        create(:membership, repo: repo)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        activator.deactivate

        expect(repo.active?).to be_falsy
      end

      it 'removes gitlab hook' do
        gitlab_api = stub_gitlab_api
        token = "gitlabtoken"
        repo = create(:repo)
        create(:membership, repo: repo)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        activator.deactivate

        expect(gitlab_api).to have_received(:delete_project_hook)
        expect(repo.hook_id).to be_nil
      end

      it 'returns true if the repo activates successfully' do
        stub_gitlab_api
        token = "gitlabtoken"
        membership = create(:membership)
        repo = membership.repo
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        result = activator.deactivate

        expect(result).to be_truthy
      end
    end

    context 'when repo activation succeeds' do
      it 'returns false if the repo does not activate successfully' do
        repo = double('repo')
        token = nil
        expect(Gitlab).to receive(:client).and_raise(Gitlab::Error::BadRequest.new)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        result = activator.deactivate

        expect(result).to be_falsy
      end

      it 'only swallows Gitlab errors' do
        repo = double('repo')
        token = nil
        expect(Gitlab).to receive(:client).and_raise(Exception.new)
        activator = RepoActivator.new(gitlab_token: token, repo: repo)

        expect do
          activator.deactivate
        end.to raise_error(Exception)
      end
    end
  end

  def stub_gitlab_api
    hook = double(:hook)
    api = double(:gitlab, add_project_hook: true, delete_project_hook: true, add_team_member: true)
    allow(hook).to receive(:to_hash).and_return({"id" => 1})
    allow(api).to receive(:add_project_hook).and_return(hook)
    allow(Gitlab).to receive(:client).and_return(api)
    api
  end
end
