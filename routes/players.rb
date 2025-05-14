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

  player = Player.update(params[:id].to_i, data)
  if player.nil?
    halt 404, { error: 'Match not found' }.to_json
  end

  { success: true }.to_json
end

patch '/players/:id' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)

  updated = Player.update_partial(params[:id].to_i, data)
  if updated
    status 200
    { success: true }.to_json
  else
    halt 404, { error: 'Player not found' }.to_json
  end
end


delete '/players/:id' do
  Player.delete(params[:id].to_i)
  status 204
end
