module OauthHelper
  def stub_oauth(options = {})
    OmniAuth.config.add_mock(
      :gitlab,
      info: {
        nickname: options[:nickname],
        email: options[:email]
      },
      credentials: {
        token: options[:token]
      }
    )
  end
end
