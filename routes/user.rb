
class App

  post '/login' do
    unless session[:uid]
      puts @body[:email], @body[:password]
      if user = GitContacts::password_valid?(@body[:email], @body[:password])
        # mark email as uid
        session[:uid] = @body[:email]
        @return_message[:success] = 1
      else
        status 401
        @return_message[:errmsg] = "Email and password combination incorrect."
      end
    else
      status 403
      @return_message[:errmsg] = 'has been login'
    end
    @return_message.to_json
  end
  
  post '/register' do 
    unless session[:uid]
      if GitContacts::create_user(@body)
        session[:uid] = @body[:email]
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Create user failed."
        status 409
      end
    else
      @return_message[:errmsg] = "has been login"
      status 403
    end
    @return_message.to_json
  end

  get '/logout' do
    if session[:uid]
      @return_message[:success] = 1
      session.clear
    else
      @return_message[:errmsg] = "Not login."
      status 403
    end
    @return_message.to_json
  end

  get '/contacts/:contacts_id/users' do
    if uid = session[:uid]
      @return_message[:success] = 1
      @return_message[:users] = GitContacts::get_contacts_users uid, params[:contacts_id]
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  delete '/contacts/:contacts_id/user/:user_id' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_user_privileges(uid, params[:contacts_id], params[:user_id], params[:payload])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Delete user from contacts failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  put '/contacts/:contacts_id/user/:user_id/privilege' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_user_privileges(uid, params[:contacts_id], params[:user_id], params[:payload])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Change user privilege failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

end