Rails.application.config.middleware.use OmniAuth::Builder do
  #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end