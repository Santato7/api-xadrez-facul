require 'sinatra'
require_relative './routes/matches'
require_relative './routes/players'
require_relative './routes/setup'

get '/docs' do
  redirect to('/docs/index.html')
end

get '/swagger.yaml' do
  content_type 'application/yaml'
  File.read('swagger.yaml')
end