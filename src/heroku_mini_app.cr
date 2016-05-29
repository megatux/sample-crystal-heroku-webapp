require "http/server"
require "option_parser"
require "ohm"

bind = "0.0.0.0"
port = 8080

Ohm.redis = Resp.new ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379")
Ohm.redis.call "SET", "app-name", "heroku_mini_app"

OptionParser.parse! do |opts|
  opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
    port = opt.to_i
  end
end

server = HTTP::Server.new(bind, port) do |context|
  context.response.content_type = "text/plain"
  context.response << "Hello world, got #{context.request.path}"
  context.response << "\nRedis get: #{Ohm.redis.call("GET", "app-name")}"
end

puts "Listening on http://#{bind}:#{port}"
server.listen
