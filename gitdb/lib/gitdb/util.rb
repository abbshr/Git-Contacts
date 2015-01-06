module Gitil
  def self::generate_code n
    [*'a'..'z', *0..9, *'A'..'Z'].sample(n).join
  end

  def self::data_keys_of_card
    ["firstname", "lastname", "mobile", "phone", "email", "birthday", "address", "im"]
  end

  def self::meta_keys_of_card
  	["id", "owner"]
  end
end