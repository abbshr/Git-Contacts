require "json"
require "rugged"
require_relative "gitdb/util"
require_relative "gitdb/version"

require_relative 'gitdb/Card'
require_relative 'gitdb/Contacts'

module Gitdb
  
  # 主存储目录
  STORAGE_PATH = File::expand_path '../../../storage', __FILE__

  # 检查并创建主存储目录
  def self::setup_storage
    Dir::mkdir STORAGE_PATH unless Dir::exist? STORAGE_PATH
  end

end
