
class App

  post '/login' do
    return_message = {}
    status = 401
    unless session[:uid]
      if GitContacts::password_valid?(params[:uid], params[:password])
        session[:uid] = params[:uid]
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Email and password combination incorrect."
      end
    else
      return_message[:errmsg] = 'has been login'
    end
    return_message.to_json
  end
  
  post '/register' do 
    return_message = {}
    status = 409 # conflict
    unless session[:uid]
      if session[:uid] = GitContacts::create_user(params[:user_info])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Create user failed."
      end
    else
      return_message[:errmsg] = "has been login"
    end
    return_message.to_json
  end

  get '/logout' do
    return_message = {}
    status = 401 # unauthorized
    if session[:uid]
      status = 200
      return_message[:success] = 1
      session.delete :uid
    else
      return_message[:errmsg] = "Not login."
    end
    return_message.to_json
  end

  get '/contacts/:contacts_id/users' do
    return_message = {}
    status = 401
    if uid = session[:uid]
      status = 200
      return_message[:success] = 1
      return_message[:users] = GitContacts::get_contacts_users uid ,params[:contacts_id]
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  delete '/contacts/:contacts_id/user/:user_id' do
    return_message = {}
    status = 401
    if uid = session[:uid]
      if GitContacts::edit_contacts_user_privileges(uid, params[:contacts_id], params[:user_id], params[:payload])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Delete user from contacts failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  put '/contacts/:contacts_id/user/:user_id/privilege' do
    return_message = {}
    status = 401
    if uid = check_token
      if GitContacts::edit_contacts_user_privileges(uid, params[:contacts_id], params[:uid], params[:payload])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Change user privilege failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

end