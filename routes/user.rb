
# code review: @abbshr
post '/login' do
  unless session[:uid]
    if GitContacts::password_valid?(@body[:email], @body[:password])
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
    GitContacts::create_user(@body)
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
      session[:uid] = @body[:email]
    when :miss_args
      @return_message[:errmsg] = 'Missing Email or Password'
      status 400
    when :exist
      @return_message[:errmsg] = 'Email has been Taken'
      status 409
    end
  else
    @return_message[:errmsg] = "has been login"
    status 403
  end
  @return_message.to_json
end

# code review: @abbshr
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

get '/users' do
  if uid = session[:uid]
    @return_message[:users] = GitContacts::get_users uid
    @return_message[:success] = 1 if GitContacts::errsym == :ok
  else
    @return_message[:errmsg] = "Token invalid"
    status 401
  end
  @return_message.to_json
end

get '/user/:user_id' do
  if uid = session[:uid]
    @return_message[:user] = GitContacts::get_a_user uid, params[:user_id]
    case GitContacts::errsym
    when :ok 
      @return_message[:success] = 1
    when :non_exist 
      @return_message[:errmsg] = "User Not Found"
      status 404
    end
  else
    @return_message[:errmsg] = "Token invalid"
    status 401
  end
  @return_message.to_json
end

# code review: @abbshr
get '/contacts/:contacts_id/users' do
  if uid = session[:uid]
    @return_message[:users] = GitContacts::get_contacts_users uid, params[:contacts_id]
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    end
  else
    @return_message[:errmsg] = "Token invalid."
    status 401
  end
  @return_message.to_json
end

post '/contacts/:contacts_id/user' do
  if uid = session[:uid]
    GitContacts::add_contacts_user uid, params[:contacts_id], @body[:uid]
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :non_exist
      @return_message[:errmsg] = 'User Not Found'
      status 404
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    end
  else
    @return_message[:errmsg] = 'Token invalid'
    status 401
  end
  @return_message.to_json
end

get '/contacts/:contacts_id/user/:user_id/privilege' do
  if uid = session[:uid]
    @return_message[:privilege] = GitContacts::get_contacts_user_privileges(uid, params[:contacts_id], params[:user_id])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    end
  else
    status 401
    @return_message[:errmsg] = "Token invaild"
  end
  @return_message.to_json
end

# code review: @AustinChou
delete '/contacts/:contacts_id/user/:user_id' do
  if uid = session[:uid]
    GitContacts::remove_contacts_user(uid, params[:contacts_id], params[:user_id])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    end
  else
    @return_message[:errmsg] = "Token invalid."
    status 401
  end
  @return_message.to_json
end

# code review: @AustinChou
patch '/contacts/:contacts_id/user/:user_id/privilege' do
  if uid = session[:uid]
    GitContacts::edit_contacts_user_privileges(uid, params[:contacts_id], params[:user_id], @body[:role])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :bad_args
      @return_message[:errmsg] = 'Invalid role'
      status 400
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    end
  else
    @return_message[:errmsg] = "Token invalid."
    status 401
  end
  @return_message.to_json
end
