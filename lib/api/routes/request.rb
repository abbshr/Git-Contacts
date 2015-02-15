class App
  # code review: @AustinChou
  get '/contacts/:contacts_id/requests' do
    if uid = session[:uid]
      @return_message[:requests] = GitContacts::get_all_requests params[:contacts_id]
      @return_message[:success] = 1 if GitContacts::errsym == :ok
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  get '/contacts/:contacts_id/request/:request_id' do
    if uid = session[:uid]
      @return_message[:request] = GitContacts::get_a_request params[:contacts_id], params[:request_id]
      case GitContacts::errsym
      when :ok
        @return_message[:success] = 1
      when :non_exist
        @return_message[:errmsg] = 'Request Not Found'
        status 404
      end
    else
      @return_message[:errmsg] = "Token invalid"
      status 401
    end
    @return_message.to_json
  end

  # code review: @AustinChou
  patch '/contacts/:contacts_id/request/:request_id/status' do
    if uid = session[:uid]
      GitContacts::edit_request_status(uid, params[:contacts_id], params[:request_id], @body[:action])
      case GitContacts::errsym
      when :ok
        @return_message[:success] = 1
      when :forbidden
        @return_message[:errmsg] = 'Access Forbidden'
        status 403
      when :non_exist
        @return_message[:errmsg] = 'Request Not Found'
        status 404
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end
end
