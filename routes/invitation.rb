
class App
  # "users": [{ uid: "xxx" }]
  post '/contacts/:contacts_id/invitation' do
    if uid = session[:uid]
      if GitContacts::invite_contacts_user(uid, params[:contacts_id], @body[:users])
        @return_message[:success] = 1
        status 201
      else
        @return_message[:errmsg] = "Create invitation failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  put '/invitation' do
    if uid = session[:uid]
      if GitContacts::edit_invitation_status(uid, params[:payload])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Edit invitation failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end
end