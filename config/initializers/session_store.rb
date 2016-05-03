# Be sure to restart your server when you modify this file.

# manage session by rails cookie
def use_default(message)
  Rails.logger.error(message)
  Rails.application.config.session_store :cookie_store, key: '_my100tales_session'
end

# manage session by redis
def use_redis(config)
  Rails.application.config.session_store :redis_store, servers: {
      # password: config[:password],
      host: config[:host],
      port: config[:port],
      db: config[:db],
      namespace: config[:namespace],
  }, expire_after: eval(config[:expire_after])
end

# util for redis setting
def yml_include_erb(params)
  results = {}
  params.each { |key, value|
    results[key] = ERB.new(value.to_s).result(binding)
  }
  return results
end

# main
config_file = File.join(Rails.root, 'config', 'redis_store.yml')
if File.exists?(config_file)
  begin
    config = YAML.load_file(config_file)[Rails.env].symbolize_keys
    config = yml_include_erb(config)
    begin
      use_redis(config)
    rescue
      use_default('connection to redis is failed!')
    end
  rescue
    use_default("#{config_file} is missing!")
  end
else
  use_default("#{config_file} is missing!")
end
