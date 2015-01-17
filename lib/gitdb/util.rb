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

  class Hash
    def sub_hash *args
      tmp = {}
      args.each do |k|
        tmp[k] = self[k] if self.has_key? k
      end
      tmp
    end
  end
end