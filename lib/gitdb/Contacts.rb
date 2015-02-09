
module Gitdb
  class Contacts

    # 线程锁
    @@lock = Mutex.new

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

      # 同步信号量
      @@lock.synchronize {
        # 生成联系人的唯一编码
        while exist?(@gid = Gitil::generate_code(4)) 
        end
        # 创建并打开git仓库
        @repo = Rugged::Repository.init_at "#{STORAGE_PATH}/#{@gid}"
      }
      puts name, @gid, @uid
      # 设置元信息
      setmeta :name => name, :gid => @gid, :owner => @uid
      # 读取最后一次提交指向的tree的数据到暂存区
      @repo.index.read_tree @repo.last_commit.tree unless @repo.head_unborn?
      # 返回Contacts实例
      self
    end

    def access gid
      if exist?(@gid = gid)
        @repo = Rugged::Repository.new "#{STORAGE_PATH}/#{gid}"
        # 读取最后一次提交指向的tree的数据到暂存区
        @repo.index.read_tree @repo.last_commit.tree unless @repo.head_unborn?
        self
      else
        nil
      end
    end
    
    # 返回Card实例
    def get_card_by_id id
      if @repo.head_unborn?
        nil
      else
        Card.new(@repo).access id
      end
    end

    # 条件查询
    # 返回Card实例集合
    def get_cards &condition
      if @repo.head_unborn?
        []
      else
        @repo.head.target.tree.map do |o|
          yield Card.new(@repo).access o[:name]
        end.compact
      end
    end

    # 返回Card实例集合
    def get_all_cards
      get_cards { |card| card }
    end

    def getmeta
      @meta = {
        :name => @repo.config['repo.name'],
        :owner => @repo.config['repo.owner'],
        :gid => @repo.config['repo.gid'],
        # 动态获取contacts中card数量
        :count => @repo.head_unborn? ? 0 : @repo.last_commit.tree.count
      }
    end
    
    def setmeta hash
      @repo.config['repo.name'] = hash[:name] if hash.member? :name
      @repo.config['repo.owner'] = hash[:owner] if hash.member? :owner
      @repo.config['repo.gid'] = hash[:gid] if hash.member? :gid
    end

    # 返回commit对象oid
    def read_change_history &block
      if @repo.head_unborn?
        []
      else
        walker = Rugged::Walker.new repo
        walker.push repo.last_commit
        walker.map(&block).compact 
      end
    end

    # 等同于git工具的 "Revert"操作
    # @sha = commit oid
    # @options = { 
    #   :message => '', 
    #   :author => {:name=> '', :email=> '', :time=> Time}, 
    #   :committer => {:name=> '', :email=> '', :time=> Time} 
    # }
    #
    def revert_to sha, options
      return nil if @repo.head_unborn?
      commit = @repo.lookup sha
      tree = commit.tree
      # 构造tree
      @repo.index.read_tree tree
      # 提交暂存区的tree
      make_a_commit options
    end
    
    # 生成一个commit对象
    # 每次修改最终要调用
    # @options = { 
    #   :message => '', 
    #   :author => {:name=> '', :email=> '', :time=> Time}, 
    #   :committer => {:name=> '', :email=> '', :time=> Time} 
    # }
    #
    def make_a_commit options
      if @repo.index.count == 0 && @repo.head_unborn?
        return nil
      end
      options[:message] = 'make a commit' unless options.include? :message
      options[:tree] = @repo.index.write_tree @repo
      options[:parents] = @repo.empty? ? [] : [@repo.head.target].compact
      options[:update_ref] = 'HEAD'
      Rugged::Commit.create @repo, options
    end
  end
  
end