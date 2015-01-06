require "rugged"
require "json"
require "gitdb/util"
require "Card"

class Contacts

  def initialize uid
    @uid = uid
  end

  def self::exist? gid
    Dir::exist? gid
  end

  def exist? gid
    Contacts::exist? gid
  end

  def create name
    # generate a unique hash code
    while exist? @gid = Gitil::generate_code 4 end
    # create & open repository
    @repo = Rugged::Repository.init_at @gid
    # setup meta data
    setmeta :name => name, :gid => @gid, :uid => @uid
  end

  def access gid
    @repo = Rugged::Repository.new gid if exist? gid
  end

  def get_all_cards
    @repo.head.target.tree.collect.each { |o| o[:name] }
  end

  def get_card_by_id id
    @repo.head.target.tree.find do |o|
      Card::getdata id if o[:name] == id
    end
  end

  def getmeta
    @meta = {
      :name => @repo.config['repo.name'],
      :uid => @repo.config['repo.owner'],
      :gid => @repo.config['repo.gid']
    }
  end

  def setmeta hash
    @repo.config['repo.name'] = hash[:name] if hash.member? :name
    @repo.config['repo.owner'] = hash[:owner] if hash.member? :owner
    @repo.config['repo.gid'] = hash[:gid] if hash.member? :gid
  end

  def read_change_history
    walker = Rugged::Walker.new repo
    walker.push repo.last_commit
    walker.collect.each { |commit| commit }
  end

  # perform a "Revert" opreation
  def revert_to sha, author, message
    tree = @repo.lookup sha
    tree.each do |e|
      # construct new tree from stage
      write_to_stage e[:name], JSON.parse @repo.lookup(e[:oid]).content
    end
    # get committer info
    committer = get_card_by_id(@uid).merge :time => Time.now
    # commit to repo
    make_a_commit :author => author, :message => message, :committer => committer
  end

  def write_to_stage card_id, content
    oid = @repo.write content, :blob
    @repo.index.read_tree @repo.head.target.tree
    @repo.index.add :path => card_id, :oid => oid, :mode => 0100644
  end

  def make_a_commit options
    options[:tree] = @repo.index.write_tree @repo
    options[:parents] = @repo.empty? ? [] : [@repo.head.target].compact
    options[:update_ref] = 'HEAD'
    Rugged::Commit.create @repo, options
  end
end