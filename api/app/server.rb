require_relative 'app'

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 4000,
  Host: '0.0.0.0'
)
