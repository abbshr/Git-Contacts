
class App
  post '/contacts/:contacts_id/invitation' do
    return_message = {}
    status = 401
    if uid = session[:uid]
      if return_message[:request_id] = GitContacts::invite_contacts_user(uid, params[:contacts_id], params[:payload])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Create invitation failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  put '/invitation' do
    return_message = {}
    status = 401
    if uid = session[:uid]
      if GitContacts::edit_invitation_status(uid, params[:payload])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Edit invitation failed."
      end
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end
end