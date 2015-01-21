#$LOAD_PATH << "#{Dir::pwd}/lib" unless $LOAD_PATH.include? "#{Dir::pwd}/lib"

require 'sinatra/base'
require 'redis-sinatra'
require 'json'
require 'redis'
require 'gitcontacts'

class GCApp < Sinatra::Base
  # redis-sinatra cache
  register Sinatra::Cache

  # before configuration
  before do
    content_type 'application/json'

    if request.body.size > 0
      request.body.rewind
      @request_payload = JSON.parse(request.body.read, :symbolize_names => true)
    end

    @request_payload[:token] = @request_payload[:token] || params[:token]
  end

  # global configuration
  configure do
    set :port, 8080
    set :logging, true
    set :lock, true
  end

  def check_token
    if token = @request_payload[:token]
      settings.cache.read "token_#{token}"
    end
  end

  def token_exist? token
    settings.cache.read "token_#{token}"
  end

  class Hash
    def to_json
      require 'json'
      JSON.generate self
    end
  end
=begin
  post '/login' do
    return_message = {}
    status = 401
    if GCService::password_valid? @request_payload
      new_token = nil
      while token_exist?(new_token = GCUtil::generate_code(16))
      end
      settings.cache.write "token_#{new_token}", GCUser::username_to_uid(@request_payload[:email])
      return_message[:token] = new_token
      status = 200
    else
      return_message[:errmsg] = "Email and password combination incorrect."
    end
    [status, return_message.to_json]
  end

  post '/register' do 
    return_message = {}
    status = 409 # conflict
    if GCService::create_user @request_payload
      status = 200
    else
      return_message[:errmsg] = "Create user failed."
    end
    [status, return_message.to_json]
  end

  get '/logout' do
    return_message = {}
    status = 401 # unauthorized
    if check_token
      if settings.cache.delete('token_'+@request_payload[:token])
        status = 200
      else
        return_message[:errmsg] = "Logout failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end
=end

  get '/contacts' do
    # params[:filter]
    return_message = {}
    status = 401
    if uid = 'qwer'#check_token
      status = 200
      return_message[:success] = 1
      return_message[:contacts] = GitContacts::get_all_contacts uid
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  post '/contacts' do
    return_message = {}
    status = 401
    if uid = 'qwer'#check_token
      if return_message[:contacts_id] = GitContacts::add_contacts(uid, @request_payload)
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Create contacts failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  # 获取cards
  get '/contacts/:contacts_id/cards' do
    #params[:filter] : 
    #params[:count]
    #params[:number]
    #params[:]
    return_message = {}
    status = 401
    if uid = "qwer"#check_token
      status = 200
      return_message[:success] = 1
      return_message[:cards] = GitContacts::get_contacts_cards_by_related uid, params[:contacts_id], params[:keyword]
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  get '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = "qwer"#check_token
      if return_message[:card] = GitContacts::get_contacts_card(uid, params[:contacts_id], params[:card_id])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Card not found."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  post '/contacts/:contacts_id/card' do
    return_message = {}
    status = 401
    if uid = "qwer"#check_token
      if return_message[:card_id] = GitContacts::add_contacts_card(uid, params[:contacts_id], @request_payload)
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Create card failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  put '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = "qwer"#check_token
      if GitContacts::edit_contacts_card(uid, params[:contacts_id], params[:card_id], @request_payload)  
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Edit card failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  delete '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = "qwer"#check_token
      if GitContacts::delete_contacts_card(uid, params[:contacts_id], params[:card_id])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Delete card failed."
      end
    else
      return_message[:errmsg] = "Token invalid".
    end
    return_message.to_json
  end
=begin
  get '/contacts/:contacts_id/requests' do
   return_message = {}
    status = 401
    if uid = "qwer"#check_token
      status = 200
      return_message[:requests] = GitContacts::get_all_requests uid
    else
      return_message[:token] = "Token invalid."
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/request/:request_id/status' do
    return_message = {}
    status = 401
    if uid = check_token
      if GitContacts::edit_request_status( uid, params[:contacts_id], params[:request_id], @request_payload)
        status = 200
      else
        return_message[:errmsg] = "Change request status failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end

  get '/contacts/:contacts_id/users' do
   return_message = {}
    status = 401
    if uid = check_token
      status = 200
      return_message[:users] = GCService::get_contacts_users( uid ,params[:contacts_id])
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end

  put '/contacts/:contacts_id/user/:user_id/privilege' do
    return_message = {}
    status = 401
    if uid = check_token
      if GCService::edit_contacts_user_privileges( uid, params[:contacts_id], params[:user_id] ,@request_payload)
        status = 200
      else
        return_message[:errmsg] = "Change user privilege failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end
=end
  put '/contacts/:contacts_id/metadata' do
   return_message = {}
    status = 401
    if uid = 'qwer'#check_token
      if GitContacts::edit_contacts_meta(uid, params[:contacts_id], @request_payload)
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Edit contacts metadata failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end
=begin
  post '/contacts/:contacts_id/invitation' do
    return_message = {}
    status = 401
    if uid = 'qwer'#check_token
      if return_message[:request_id] = GitContacts::invite_contacts_user(uid, params[:contacts_id], @request_payload)
        status = 200
      else
        return_message[:errmsg] = "Create invitation failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end

  put '/invitation' do
    return_message = {}
    status = 401
    if uid = check_token
      if GCService::edit_invitation_status( uid, @request_payload)
        status = 200
      else
        return_message[:errmsg] = "Edit invitation failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end

  delete '/contacts/:contacts_id/user/:user_id' do
    return_message = {}
    status = 401
    if uid = 'qwer'#check_token
      if GitContacts::edit_contacts_user_privileges( uid, params[:contacts_id], params[:user_id])
        status = 200
      else
        return_message[:errmsg] = "Delete user from contacts failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    [status, return_message.to_json]
  end
=end
  get '/contacts/:contacts_id/history' do
    return_message = {}
    status = 401
    uid = 'qwer'
    if return_message = GitContacts::get_contacts_history(uid, params[:contacts_id])
      status = 200
      return_message[:success] = 1
    end
    return_message.to_json
  end

  post '/contacts/:contacts_id/history' do
    return_message = {}
    status = 401
    uid = 'qwer'
    if return_message = GitContacts::revert_to(uid, params[:contacts_id], params[:oid])
      status = 200
      return_message[:success] = 1
    else
      return_message[:errmsg] = "Commit Not Found!"
    end
    return_message.to_json
  end
end