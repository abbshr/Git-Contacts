module Gitil
  def generate_code n
    [*'a'..'z', *0..9, *'A'..'Z'].sample(n).join
  end
end