require "json"
require "rugged"
require_relative "gitdb/util"
require_relative "gitdb/version"

module Gitdb
  
  STORAGE_PATH = File::expand_path '../../../storage', __FILE__
  
  class Card

    def initialize repo
      @repo = repo
    end

    def self::exist? repo, id
      repo.head.target.tree.find { |o| o[:name] == id } unless repo.branches.count == 0
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
      while exist?(@id = Gitil::generate_code(4)) 
      end
      # setup card-owner's id
      @uid = uid
      # setup card format
      @content = format_card @id, @uid
      self
    end

    def access id
      @id = id
      o = @repo.head.target.tree.find do |o|
        o if o[:name] == id
      end
      @content = JSON.parse @repo.lookup(o[:oid]).content, { symbolize_names: true }
      @uid = @content[:owner]
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
      data = @content.clone
      data.delete :meta
      data
    end

    def setdata hash
      h = Gitil::data_keys_of_card.map { |key| key.to_sym } & hash.keys
      h.each do |sym_key|
        @content[sym_key] = hash[sym_key]
      end
      write_to_stage @id, JSON.pretty_generate(@content)
    end

    def getmeta
      @content.clone[:meta]
    end

    def setmeta hash
      @content[:meta] = hash
    end

    def delete
      @repo.index.read_tree @repo.head.target.tree unless @repo.branches.count == 0
      @repo.index.find { |blob| @repo.index.remove blob[:path] if blob[:path] == @id }
    end

    def write_to_stage id, content
      oid = @repo.write content, :blob
      @repo.index.read_tree @repo.head.target.tree unless @repo.branches.count == 0
      @repo.index.add :path => id, :oid => oid, :mode => 0100644
    end
  end

  class Contacts

    attr_accessor 'repo'
    
    def initialize uid
      @uid = uid
    end

    def self::exist? gid
      Dir::exist? "#{STORAGE_PATH}/#{gid}"
    end

    def exist? gid
      Contacts::exist? gid
    end

    def create name
      # generate a unique hash code
      while exist?(@gid = Gitil::generate_code(4)) 
      end
      # create & open repository
      @repo = Rugged::Repository.init_at "#{STORAGE_PATH}/#{@gid}"
      # setup meta data
      setmeta :name => name, :gid => @gid, :uid => @uid
    end

    def access gid
      puts "#{STORAGE_PATH}/#{gid}"
      @repo = Rugged::Repository.new "#{STORAGE_PATH}/#{gid}" if exist? gid
    end

    def get_all_cards
      if @repo.branches.count == 0
        []
      else
        @repo.head.target.tree.collect.each { |o| Card.new(@repo).access o[:name] }
      end
    end

    def get_card_by_id id
      if @repo.branches.count == 0
        nil
      else
        @repo.head.target.tree.find do |o|
          Card.new(@repo).access id if o[:name] == id
        end
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
      if @repo.branches.count == 0
        []
      else
        walker = Rugged::Walker.new repo
        walker.push repo.last_commit
        walker.collect.each { |commit| commit }
      end
    end

    # perform a "Revert" opreation
    def revert_to sha, author, message
      if @repo.branches.count == 0
        return nil
      end

      tree = @repo.lookup sha
      tree.each do |e|
        # construct new tree from stage
        write_to_stage e[:name], JSON.parse(@repo.lookup(e[:oid]).content)
      end
      # get committer info
      committer = get_card_by_id(@uid).getdata.sub_hash(:name, :email).merge :time => Time.now
      # commit to repo
      make_a_commit :author => author, :message => message, :committer => committer
    end

    def write_to_stage card_id, content
      oid = @repo.write content, :blob
      @repo.index.add :path => card_id, :oid => oid, :mode => 0100644
    end

    def make_a_commit options
      options[:tree] = @repo.index.write_tree @repo
      options[:parents] = @repo.empty? ? [] : [@repo.head.target].compact
      options[:update_ref] = 'HEAD'
      Rugged::Commit.create @repo, options
    end
  end

end
