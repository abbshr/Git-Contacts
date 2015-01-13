
module Gitdb
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

    # 设置名片默认格式
    # Notice: 每个hash的key为Symbol类型
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
      # 生成唯一的名片id
      while exist?(@id = Gitil::generate_code(4)) 
      end
      # 记录名片创建者id
      @uid = uid
      # 用默认格式初始化名片可读内容
      @content = format_card @id, @uid
      # 返回Card实例
      self
    end

    def access id
      @id = id
      o = @repo.head.target.tree.find do |o|
        o if o[:name] == id
      end
      # 找到名片后加载名片数据, 并返回Card实例, 否则返回nil
      if o != nil
        @content = JSON.parse @repo.lookup(o[:oid]).content, { symbolize_names: true }
        @uid = @content[:owner]
        self
      else
        nil
      end
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
      # 每次对数据的修改会触发一次"写入暂存区"
      write_to_stage @id, JSON.pretty_generate(@content)
    end

    def getmeta
      @content.clone[:meta]
    end

    def setmeta hash
      @content[:meta] = hash
    end
    
    # Notice: 调用delete之后需要先commit, 然后才能继续调用write_to_stage
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
  
end