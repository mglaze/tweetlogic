
twitter_configs = "#{Rails.root}/config/twitter.yml"


if File.exist?(twitter_configs)
  Rails.logger.debug "Twitter API Configs"
  twitter_configs = YAML.load_file(twitter_configs)

  Twitter.configure do |config|
    config.consumer_key = twitter_configs[:consumer_key]
    config.consumer_secret = twitter_configs[:consumer_secret]
    config.oauth_token = twitter_configs[:oauth_token]
    config.oauth_token_secret = twitter_configs[:oauth_token_secret]
  end

  # ensure valid API credentials
  Twitter.token # a Twitter::Error::Unauthorized error will be raised if the credentials are invalid here
else
  raise "You'll need the Twitter API YAML file with valid configs before being able to launch the app. Sorry."
end