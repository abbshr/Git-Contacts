
module Gitdb
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
      # 生成联系人的唯一编码
      while exist?(@gid = Gitil::generate_code(4)) 
      end
      # 创建并打开git仓库
      @repo = Rugged::Repository.init_at "#{STORAGE_PATH}/#{@gid}"
      # 设置元信息
      setmeta :name => name, :gid => @gid, :uid => @uid
      # 返回Contacts实例
      self
    end

    def access gid
      if exist?(@gid = gid)
        @repo = Rugged::Repository.new "#{STORAGE_PATH}/#{gid}"
        self
      else
        nil
      end
    end
    
    # 返回Card实例集合
    def get_all_cards
      if @repo.branches.count == 0
        []
      else
        @repo.head.target.tree.collect.each { |o| Card.new(@repo).access o[:name] }
      end
    end
    
    # 返回Card实例
    def get_card_by_id id
      if @repo.branches.count == 0
        nil
      else
        Card.new(@repo).access id
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

    # 返回commit对象指向的tree-oid集合
    def read_change_history
      if @repo.branches.count == 0
        []
      else
        walker = Rugged::Walker.new repo
        walker.push repo.last_commit
        walker.collect.each { |commit| commit.tree.oid }
      end
    end

    # 等同于git工具的 "Revert"操作
    # @sha: tree oid, NOT a commit oid
    # 因为回滚需要的是tree而不是commit
    #  => commit.tree.oid
    def revert_to sha, author, message
      if @repo.branches.count == 0
        return nil
      end

      tree = @repo.lookup sha
      tree.each do |e|
        # 遍历sha tree, 重新构造tree并写入暂存区
        write_to_stage e[:name], @repo.lookup(e[:oid]).content
      end
      # get committer info
      # committer = get_card_by_id(@uid).getdata.sub_hash(:name, :email).merge :time => Time.now
      # 提交暂存区的tree
      make_a_commit :author => author, :message => message, :committer => author
    end

    private
    def write_to_stage card_id, content
      oid = @repo.write content, :blob
      @repo.index.add :path => card_id, :oid => oid, :mode => 0100644
    end
    
    # 生成一个commit对象
    # 每次修改最终要调用
    def make_a_commit options
      options[:tree] = @repo.index.write_tree @repo
      options[:parents] = @repo.empty? ? [] : [@repo.head.target].compact
      options[:update_ref] = 'HEAD'
      Rugged::Commit.create @repo, options
    end
  end
  
end