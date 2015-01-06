require "json"

class Card

  private
  def gen_card_id
    [*'a'..'z', *0..9].sample(8).join
  end

  def initialize gid, uid
    
  end

  def self::exist? gid, id
    File::exist? "#{gid}/#{id}"
  end

  def exist? id
    Card::exist? @gid, id
  end

  def create
    
  end

  def access
    
  end

  def getdata id
    
  end

  def setdata id, hash
  
  end

  def getmeta id
    
  end

  def setmeta id, hash
    
  end

  def delete id
    
  end
end
