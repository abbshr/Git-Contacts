require "json"
require "gitdb/util"

class Card

  def initialize repo
    @repo = repo
  end

  def self::exist? id, repo

  end

  def exist? id
    
  end

  def self::create uid, repo
  end

  def create uid
    # generate a unique hash code
    while exist? @id = Gitil::generate_code 4 end
    # create & open card
    @card = File.open("#{@gid}/#{@id}", 'w')
    # setup meta data
    setmeta :id => @id, :uid => uid, :gid => @gid
    @card
  end

  def access id
    # return blob
    # we already have @id, then we should return blob

    JSON.parse(@blob.read_raw.data, :symbolize_names => true)
  end

  def self::getdata repo, id
    Card.new(repo).getdata(id)
  end

  def self::setdata repo, id, hash
    Card.new(repo).setdata(id, hash)
  end

  def self::getmeta repo, id
    Card.new(repo).getmeta(id)
  end

  def self::setmeta repo, id, hash
    Card.new(repo).setmeta(id, hash)
  end

  def getdata id
    json = access id
    data = {}
    Gitil::data_keys_of_card.each do |key|
      sym_key = key.to_sym
      data[sym_key] = json[sym_key]
    end
    data
  end

  def setdata id, hash
    data = getdata id
    h = Gitil::data_keys_of_card.map { |key| key.to_sym } & hash.keys
    h.each do |sym_key|
      data[sym_key] = hash[sym_key]
    end
    # commit change here
  end

  def getmeta id
    json = access id
    meta = {}
    Gitil::meta_keys_of_card.each do |key|
      sym_key = key.to_sym
      data[sym_key] = json[sym_key]
    end
    data
  end

  def setmeta id hash
    data = getmeta id
    h = Gitil::meta_keys_of_card.map { |key| key.to_sym } & hash.keys
    h.each do |sym_key|
      data[sym_key] = hash[sym_key]
    end
    # commit change here
  end

  def delete id
    
  end
end
