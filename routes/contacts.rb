
class App

  # => /contacts?count=20&name=family
  get '/contacts' do
    if uid = session[:uid]
      @return_message[:success] = 1
      @return_message[:contacts] = GitContacts::get_contacts_if uid do |contacts|
        case @body[:filter]
        when 'eq'
          cond = contacts[:count] == @body[:count].to_i
        when 'gt'
          cond = contacts[:count] >= @body[:count].to_i
        when 'lt'
          cond = contacts[:count] <= @body[:count].to_i
        else
          cond = true
        end
        cond && contacts[:name].include?(@body[:name] || '')
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  post '/contacts' do
    if uid = session[:uid]
      if @return_message[:contacts_id] = GitContacts::add_contacts(uid, @body[:contacts_name])
        @return_message[:success] = 1
        status 201
      else
        @return_message[:errmsg] = "Create contacts failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  put '/contacts/:contacts_id/metadata' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_meta(uid, @body[:contacts_id], @body[:metadata])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Edit contacts metadata failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end
  
  get '/contacts/:contacts_id/history' do
    uid = session[:uid]
    if @return_message[:history] = GitContacts::get_contacts_history(uid, @body[:contacts_id])
      @return_message[:success] = 1
    end
    @return_message.to_json
  end

  post '/contacts/:contacts_id/history' do
    uid = session[:uid]
    if @return_message = GitContacts::revert_to(uid, @body[:contacts_id], @body[:oid])
      @return_message[:success] = 1
      status 201
    else
      @return_message[:errmsg] = "Commit Not Found!"
      status 404
    end
    @return_message.to_json
  end
end