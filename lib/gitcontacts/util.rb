module GitContacts
  class << self
    
    def generate_code n
      [*'a'..'z', *0..9, *'A'..'Z'].sample(n).join
    end

    # List writeable keys
    def user_keys
      [:email, :password, :contacts, :requests]
    end

    def contacts_keys
      [:name, :note, :users, :admins]
    end

    def invitation_keys
      [:uid, :gid, :inviter_id]
    end

    def request_keys
      [:uid, :gid, :action, :content]
    end
  end
end