Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :gitlab,
    :site => 'http://git.dev.fwmrm.net/',
    :v => 'v3'
  )
end
