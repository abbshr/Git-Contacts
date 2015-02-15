 
# code review: @abbshr
# 获取cards
# => /contacts/id/cards?keyword=ninja_2000
get '/contacts/:contacts_id/cards' do
  if uid = session[:uid]
    @return_message[:cards] = GitContacts::get_contacts_cards_by_related(uid, params[:contacts_id], params[:keyword] || '')
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
get '/contacts/:contacts_id/card/:card_id' do
  if uid = session[:uid]
    @return_message[:card] = GitContacts::get_contacts_card(uid, params[:contacts_id], params[:card_id])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    when :non_exist
      @return_message[:errmsg] = 'Card Not Found'
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
    ret = GitContacts::add_contacts_card(uid, params[:contacts_id], @body[:payload])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
      @return_message[:card_id] = ret
    when :pend
      @return_message[:pending] = 1
      @return_message[:qid] = ret
      status 202
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
patch '/contacts/:contacts_id/card/:card_id' do
  if uid = session[:uid]
    ret = GitContacts::edit_contacts_card(uid, params[:contacts_id], params[:card_id], @body[:payload])  
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :pend
      @return_message[:pending] = 1
      @return_message[:qid] = ret
      status 202
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    when :non_exist
      @return_message[:errmsg] = 'Card Not Found'
      status 404
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
    ret = GitContacts::delete_contacts_card(uid, params[:contacts_id], params[:card_id])
    case GitContacts::errsym
    when :ok
      @return_message[:success] = 1
    when :pend
      @return_message[:pending] = 1
      @return_message[:qid] = ret
      status 202
    when :forbidden
      @return_message[:errmsg] = 'Access Forbidden'
      status 403
    when :non_exist
      @return_message[:errmsg] = 'Card Not Found'
      status 404
    end
  else
    @return_message[:errmsg] = "Token invalid"
    status 401
  end
  @return_message.to_json
end
