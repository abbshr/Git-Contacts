class App

  # 获取cards
  # => /contacts/id/cards?keyword=ninja_2000
  get '/contacts/:contacts_id/cards' do
    return_message = {}
    status = 401
    if uid = session[:uid]
      status = 200
      return_message[:success] = 1
      return_message[:cards] = GitContacts::get_contacts_cards_by_related(uid, params[:contacts_id], params[:keyword])
    else
      return_message[:errmsg] = "Token invalid."
    end
    return_message.to_json
  end

  get '/contacts/:contacts_id/card/:card_id' do
    return_message = {}
    status = 401
    if uid = session[:uid]
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
    if uid = session[:uid]
      if return_message[:card_id] = GitContacts::add_contacts_card(uid, params[:contacts_id], params[:payload])
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
    if uid = session[:uid]
      if GitContacts::edit_contacts_card(uid, params[:contacts_id], params[:card_id], params[:payload])  
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
    if uid = session[:uid]
      if GitContacts::delete_contacts_card(uid, params[:contacts_id], params[:card_id])
        status = 200
        return_message[:success] = 1
      else
        return_message[:errmsg] = "Delete card failed"
      end
    else
      return_message[:errmsg] = "Token invalid"
    end
    return_message.to_json
  end
end