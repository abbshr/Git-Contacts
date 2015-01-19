
module Gitdb
  class Card

    # 线程锁
    @@lock = Mutex.new

    def initialize repo
      @repo = repo
    end

    def self::exist? repo, id
      # 检查stage而不是tree
      nil != repo.index.get(id)
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

      # 同步信号量
      @@lock.synchronize {
        # 生成唯一的名片id
        while exist?(@id = Gitil::generate_code(4)) 
        end
        # 记录名片创建者id
        @uid = uid
        # 用默认格式初始化名片可读内容
        @content = format_card @id, @uid
        # 添加到暂存区
        add_to_stage @id, JSON.pretty_generate(@content)
      }
      
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
      add_to_stage @id, JSON.pretty_generate(@content)
    end

    def getmeta
      @content.clone[:meta]
    end

    def setmeta hash
      @content[:meta] = hash
    end
    
    def delete
      @repo.index.remove @id
    end

    def add_to_stage id, content
      oid = @repo.write content, :blob
      @repo.index.add :path => id, :oid => oid, :mode => 0100644
    end
  end
  
end