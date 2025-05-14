require 'sinatra'
require_relative './routes/matches'
require_relative './routes/players'
require_relative './routes/setup'

set :bind, '0.0.0.0'

error do
  content_type :json
  status 500
  { error: 'Erro interno do servidor' }.to_json
end

not_found do
  content_type :json
  { error: 'Recurso não encontrado' }.to_json
end

before do
  content_type :json
end

get '/api/v1/docs' do
  redirect to('/docs/index.html')
end

get '/api/v1/swagger.yaml' do
  content_type 'application/yaml'
  File.read('swagger.yaml')
end