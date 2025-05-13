require 'json'
require_relative '../models/match'

# Rotas para partidas
get '/matches' do
  content_type :json
  Match.all.to_json
end

get '/matches/:id' do
  content_type :json
  match = Match.find(params[:id].to_i)
  halt 404, { error: 'Match not found' }.to_json unless match
  match.to_json
end

post '/matches' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  match = Match.create(data)
  status 201
  match.to_json
end

put '/matches/:id' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  Match.update(params[:id].to_i, data)
  { success: true }.to_json
end

delete '/matches/:id' do
  Match.delete(params[:id].to_i)
  status 204
end
