require "json"
require "rugged"
require "gitdb/util"

class Card

  def initialize repo
    @repo = repo
  end

  def self::exist? repo, id
    #File::exist? "#{repo_dir}#{id}"
    @repo.head.target.tree.find { |o| o[:name] == id }
  end

  def exist? id
    Card::exist? @repo, id
  end

  def self::create uid, repo
  end

  # default raw_content
  def format_card id, uid
    {
      meta: {
        id: id,
        owner: uid
      },
      firstname: '',
      lastname: '',
      mobile: [],
      phone: [],
      email: [],
      address: [],
      im: [],
      birthday: '',
      note: ''
    }
  end

  def create uid
    # setup card id
    while exist? @id = Gitil::generate_code 4 end
    # setup card-owner's id
    @uid = uid
    # setup card format
    @content = format_card @id, @uid
    self
  end

  def access id
    @id = id
    @content = @repo.head.target.tree.find do |o|
      JSON.parse @repo.lookup(o[:oid]).content if o[:name] == id
    end
    @uid = content[:owner]
    self
  end

  def self::getdata repo, id
    Card.new(repo).access(id).getdata
  end

  def self::setdata repo, id, hash
    Card.new(repo).access(id).setdata hash
  end

  def self::getmeta repo, id
    Card.new(repo).access(id).getmeta
  end

  def self::setmeta repo, id, hash
    Card.new(repo).access(id).setmeta hash
  end

  def self::delete repo, id
    Card.new(repo).access(id).delete
  end

  def getdata
    @content.clone.delete :meta
  end

  def setdata hash
    h = Gitil::data_keys_of_card.map { |key| key.to_sym } & hash.keys
    h.each do |sym_key|
      @content[sym_key] = hash[sym_key]
    end
    write_to_stage id, JSON.pretty_generate @content
  end

  def getmeta
    @content.clone[:meta]
  end

  def setmeta hash
    h = Gitil::meta_keys_of_card.map { |key| key.to_sym } & hash.keys
    h.each do |sym_key|
      @content[:meta][sym_key] = hash[sym_key]
    end
    write_to_stage id, JSON.pretty_generate @content
  end

  def delete
    @repo.index.read_tree @repo.head.target.tree
    @repo.index.find { |blob| @repo.index.remove blob[:path] if blob[:path] == @id }
  end

  def write_to_stage id, content
    oid = @repo.write content, :blob
    @repo.index.read_tree @repo.head.target.tree
    @repo.index.add :path => id, :oid => oid, :mode => 0100644
  end

end
