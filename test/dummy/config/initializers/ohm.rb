# Fetches the appropriate config from config/redis_client.yml
config = Rails.application.config_for(:redis_client)

# Sets reasonable defaults, when keys are missing
host = config["host"] || "127.0.0.1"
port = config["port"] || "6379"
db = config["database"] || 0
passwd = config.key?("passwd") ? ":#{config["passwd"]}@" : nil

# Prepares the url for Redic
url = "redis://#{passwd}#{host}:#{port}/#{db}"

# Sets the calculated url in Ohm
Ohm.redis = Redic.new(url)
