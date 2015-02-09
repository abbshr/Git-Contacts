class App

  # 获取cards
  # => /contacts/id/cards?keyword=ninja_2000
  get '/contacts/:contacts_id/cards' do
    if uid = session[:uid]
      if @return_message[:cards] = GitContacts::get_contacts_cards_by_related(uid, params[:contacts_id], params[:keyword])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "contacts not found"
        status 404
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  get '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if @return_message[:card] = GitContacts::get_contacts_card(uid, @body[:contacts_id], @body[:card_id])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Card not found."
        status 404
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  post '/contacts/:contacts_id/card' do
    if uid = session[:uid]
      if @return_message[:card_id] = GitContacts::add_contacts_card(uid, params[:contacts_id], @body[:payload])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Create card failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  put '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_card(uid, @body[:contacts_id], @body[:card_id], @body[:payload])  
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Edit card failed."
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid."
      status 401
    end
    @return_message.to_json
  end

  delete '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if GitContacts::delete_contacts_card(uid, @body[:contacts_id], @body[:card_id])
        @return_message[:success] = 1
      else
        @return_message[:errmsg] = "Delete card failed"
        status 500
      end
    else
      @return_message[:errmsg] = "Token invalid"
      status 401
    end
    @return_message.to_json
  end
end