require "json"
require "gitdb/util"

class Card

  def initialize gid, uid
    
  end

  def self::exist? gid, id
    File::exist? "#{gid}/#{id}"
  end

  def exist? id
    Card::exist? @gid, id
  end

  def create
    # Gitial::generate_code 4
  end

  def access
    
  end

  def self::getdata id
    
  end

  def self::setdata id, hash
  
  end

  def getdata
    Card::getdata @id
  end

  def setdata hash
    Card::setdata @id, hash
  end

  def getmeta id
    
  end

  def setmeta id, hash
    
  end

  def delete id
    
  end
end
