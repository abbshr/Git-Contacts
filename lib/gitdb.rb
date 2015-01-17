require "json"
require "rugged"
require "gitdb/util"
require "gitdb/version"

require 'gitdb/Card'
require 'gitdb/Contacts'

module Gitdb
  
  # 主存储目录
  STORAGE_PATH = "#{Dir::pwd}/storage"

  # 检查并创建主存储目录
  def self::setup_storage
    Dir::mkdir STORAGE_PATH unless Dir::exist? STORAGE_PATH
  end

  setup_storage
end
