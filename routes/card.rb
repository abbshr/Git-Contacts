class App
  
  # code review: @abbshr
  # 获取cards
  # => /contacts/id/cards?keyword=ninja_2000
  get '/contacts/:contacts_id/cards' do
    if uid = session[:uid]
      if @return_message[:cards] = GitContacts::get_contacts_cards_by_related(uid, params[:contacts_id], params[:keyword] || '')
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
  
  # code review: @abbshr
  get '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if @return_message[:card] = GitContacts::get_contacts_card(uid, params[:contacts_id], params[:card_id])
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
  
  # code review: @abbshr
  post '/contacts/:contacts_id/card' do
    if uid = session[:uid]
      puts uid, params[:contacts_id], @body[:payload]
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
  
    # code review: @abbshr
  patch '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if GitContacts::edit_contacts_card(uid, params[:contacts_id], params[:card_id], @body[:payload])  
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
  
    # code review: @abbshr
  delete '/contacts/:contacts_id/card/:card_id' do
    if uid = session[:uid]
      if GitContacts::delete_contacts_card(uid, params[:contacts_id], params[:card_id])
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