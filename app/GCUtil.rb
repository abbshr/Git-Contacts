module GCUtil

  def self::generate_code n
  [*'a'..'z', *0..9, *'A'..'Z'].sample(n).join
  end

  def self::user_keys
    ["uid", "password", "contacts"]
  end

  def self::contacts_keys
    ["name", "repo", "users", "admins"]
  end

  def self::invitation_keys
    ["uid", "contacts"]
  end

  def self::request_keys
    ["uid", "action", "content"]
  end

end