require 'sinatra'
require 'json'
require 'redis'

set :port, 8080

def get_request_json
	JSON.parse(request.body.read)
end

def check_valid_user

end

get '/' do
	"Hello World"
end

post '/login' do

end

post '/register' do 

end

get '/logout' do

end

get '/contacts/:contact_id/cards' do

end

get '/contacts/:contact_id/card/:card_id' do

end

post '/contacts/:contact_id/card' do

end

put '/contacts/:contact_id/card/:card_id' do

end

delete '/contacts/:contact_id/card/:card_id' do

end

get '/contacts/:contact_id/requests' do

end

put '/contacts/:contact_id/request/:request_id/status' do

end

get '/contacts/:contact_id/users' do

end

put '/contacts/:contact_id/user/:user_id/privilege' do

end

post '/contacts' do

end

put '/contacts/:contact_id/metadata' do

end

post '/contacts/:contact_id/invitation' do

end

delete '/contacts/:contact_id/user/:user_id' do

end

