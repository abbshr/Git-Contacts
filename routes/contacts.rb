
class App

  # code review: @abbshr
  # => /contacts?count=20&filter=gt&name=family
  get '/contacts' do
    if uid = session[:uid]
      @return_message[:success] = 1
      @return_message[:contacts] = GitContacts::get_contacts_if uid do |contacts|
        case params[:filter]
        when 'eq'
          cond = contacts[:count] == (params[:count] || 0).to_i
        when 'gt'
          cond = contacts[:count] >= (params[:count] || 0).to_i
        when 'lt'
          cond = contacts[:count] <= (params[:count] || 0).to_i
        else
          cond = true
        end
        cond && contacts[:name].include?(params[:name] || '')
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  # code review: @abbshr
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

  get '/contacts/:contacts_id' do
    if uid = session[:uid]
      @return_message[:success] = 1
      contacts = GitContacts::get_contacts_if uid do |contact|
        contact[:gid] == params[:contacts_id]
      end
      @return_message[:contact] = contacts.first
    else
      @return_message[:errmsg] = 'Token invalid'
      status 401
    end
    @return_message.to_json
  end

  # code review: @abbshr
  put '/contacts/:contacts_id/metadata' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_meta(uid, params[:contacts_id], @body[:metadata])
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
  
  # code review: @abbshr
  get '/contacts/:contacts_id/history' do
    uid = session[:uid]
    if @return_message[:history] = GitContacts::get_contacts_history(uid, params[:contacts_id])
      @return_message[:success] = 1
    end
    @return_message.to_json
  end

  # code review: @abbshr
  post '/contacts/:contacts_id/revert' do
    uid = session[:uid]
    if @return_message[:oid] = GitContacts::revert_to(uid, params[:contacts_id], @body[:oid])
      @return_message[:success] = 1
      status 201
    else
      @return_message[:errmsg] = "Commit Not Found!"
      status 404
    end
    @return_message.to_json
  end
end