require "json"

class Card

  def initialize gid, uid
    
  end

  def self::exist? gid, id
    File::exist? "#{gid}/#{id}"
  end

  def exist? id
    Card::exist? @gid, id
  end

  def gen_id
    # TODO: id formart
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
