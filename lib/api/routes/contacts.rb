class App
  # code review: @abbshr
  # => /contacts?count=20&filter=gt&name=family
  get '/contacts' do
    if uid = session[:uid]
      params[:name] ||= ''
      params[:count] = params[:count].to_i || 0
      @return_message[:contacts] = GitContacts::get_contacts_if uid do |contacts|
        case params[:filter]
        when 'eq'
          cond = contacts[:count] == params[:count]
        when 'gt'
          cond = contacts[:count] >= params[:count]
        when 'lt'
          cond = contacts[:count] <= params[:count]
        else
          cond = true
        end
        cond && contacts[:name].include?(params[:name])
      end
      @return_message[:success] = 1 if GitContacts::errsym == :ok
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  # code review: @abbshr
  post '/contacts' do
    if uid = session[:uid]
      @return_message[:contacts_id] = GitContacts::add_contacts(uid, @body[:contacts_name])
      case GitContacts::errsym
      when :ok
        @return_message[:success] = 1
      when :miss_args
        @return_message[:errmsg] = 'Contacts Name is Required'
        status 400
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  get '/contacts/:contacts_id' do
    if uid = session[:uid]
      @return_message[:contact] = GitContacts::get_contacts_if uid do |contact| 
        contact[:gid] == params[:contacts_id] 
      end.first
      @return_message[:success] = 1 if GitContacts::errsym == :ok
    else
      @return_message[:errmsg] = 'Token invalid'
      status 401
    end
    @return_message.to_json
  end

  # code review: @abbshr
  patch '/contacts/:contacts_id' do
    if uid = session[:uid]
      GitContacts::edit_contacts_meta(uid, params[:contacts_id], @body[:metadata])
      case GitContacts::errsym
      when :ok
        @return_message[:success] = 1
      when :miss_args
        @return_message[:errmsg] = 'Metadata is Required'
        status 400
      when :forbidden
        @return_message[:errmsg] = "Access Forbidden"
        status 403
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  # code review: @abbshr
  get '/contacts/:contacts_id/history' do
    if uid = session[:uid]
      @return_message[:history] = GitContacts::get_contacts_history(uid, params[:contacts_id])
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

  # code review: @abbshr
  post '/contacts/:contacts_id/revert' do
    if uid = session[:uid]
      @return_message[:oid] = GitContacts::revert_to(uid, params[:contacts_id], @body[:oid])
      case GitContacts::errsym
      when :ok
        @return_message[:success] = 1
      when :forbidden
        @return_message[:errmsg] = 'Access Forbidden'
        status 403
      when :non_exist
        @return_message[:errmsg] = 'Commit Not Found'
        status 404
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end
end
