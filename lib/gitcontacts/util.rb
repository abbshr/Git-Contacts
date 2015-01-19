module GitContacts

  def self::generate_code n
    [*'a'..'z', *0..9, *'A'..'Z'].sample(n).join
  end

  # List writeable keys
  def self::user_keys
    [:email, :password, :contacts, :requests]
  end

  def self::contacts_keys
    [:name, :users, :admins]
  end

  def self::invitation_keys
    [:uid, :gid, :inviter_id]
  end

  def self::request_keys
    [:uid, :gid, :card_id, :action, :content]
  end

end