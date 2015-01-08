require 'sinatra'
require 'redis-sinatra'
require 'json'
require 'redis'
require 'digest/sha1'
require 'GCService'

class GGApp < Sinatra::Base
  # redis-sinatra cache
  register Sinatra::Cache

  set :port, 8080

  # before configuration
  before do
    content_type 'application/json'

    if request.body.size > 0
      request.body.rewind
      @request_payload = JSON.parse(request.body.read, :symbolize_names => true)
    end
  end

  def check_token
    if token = @request_payload[:token]
      
    end
  end

  post '/login' do
    return_message = {}
    status = 401
    if GCService::password_valid? @request_payload[:email] @request_payload[:password]
      return_message[:token] = NEW_TOKEN
      status = 200
    end
    [status, return_message.to_json]
  end

  post '/register' do 
    return_message = {}
    status = XXX
    if GCService::create_user @request_payload
      status = 200
    end
    [status, return_message.to_json]
  end

  get '/logout' do
    return_message = {}
    status = 401
    if check_token
      status = 200 if settings.cache.del(XXX)
    end
    [status, return_message.to_json]
  end

  get '/contacts/:contacts_id/cards' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::get_contacts_all_cards uid :contacts_id
    end
    [status, return_message.to_json]
  end

  get '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::get_contacts_card uid :contacts_id :card_id
    end
    [status, return_message.to_json]
  end

  post '/contacts/:contacts_id/card' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::new_contacts_card uid :contacts_id @request_payload      
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::edit_contacts_card uid :contacts_id :card_id @request_payload  
    end
    [status, return_message.to_json]
  end

  delete '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::delete_contacts_card uid :contacts_id :card_id
    end
    [status, return_message.to_json]
  end

  get '/contacts/:contacts_id/requests' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::get_all_requests uid
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/request/:request_id/status' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::edit_request_status uid :contacts_id :request_id
    end
    [status, return_message.to_json]
  end

  get '/contacts/:contacts_id/users' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200 if return_message[:data] = GCService::get_contacts_users uid :contacts_id      
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/user/:user_id/privilege' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::edit_contacts_user_privileges uid :contacts_id :user_id
    end
    [status, return_message.to_json]
  end

  post '/contacts' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::add_contacts uid @request_payload
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/metadata' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::edit_contacts_meta uid :contacts_id @request_payload
    end
    [status, return_message.to_json]
  end

  post '/contacts/:contacts_id/invitation' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::invite_contacts_user uid :contacts_id @request_payload
    end
    [status, return_message.to_json]
  end

  put '/invitation' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::edit_invitation_status uid @request_payload
    end
    [status, return_message.to_json]
  end

  delete '/contacts/:contacts_id/user/:user_id' do
    return_message = {}
    status = 401
    if uid = check_token
      status = 200 if GCService::edit_contacts_user_privileges uid :contacts_id :user_id
    end
    [status, return_message.to_json]
  end

end