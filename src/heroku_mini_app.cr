require "./heroku_mini_app/*"

require "json"
require "ohm"
require "kemal"

# module HerokuMiniApp
# end

port = 8080

Ohm.redis = Resp.new ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379")
Ohm.redis.call "SET", "app-name", "heroku_mini_app"

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

get "/" do |env|
  "Hello world, got #{env.request.path}" +
    "\nRedis get: #{Ohm.redis.call("GET", "app-name")}"
end

get "/app_info" do |env|
  env.response.content_type = "application/json"
  {app_name: Ohm.redis.call("GET", "app-name")}.to_json
end

Kemal.config do |config|
  config.port = port
end

Kemal.run
