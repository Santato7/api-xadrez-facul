require 'json'
require_relative '../models/player'

get '/players' do
  content_type :json
  Player.all.to_json
end

get '/players/:id' do
  content_type :json
  player = Player.find(params[:id].to_i)
  halt 404, { error: 'Player not found' }.to_json unless player
  player.to_json
end

post '/players' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  player = Player.create(data)
  status 201
  player.to_json
end

put '/players/:id' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  Player.update(params[:id].to_i, data)
  { success: true }.to_json
end

delete '/players/:id' do
  Player.delete(params[:id].to_i)
  status 204
end
