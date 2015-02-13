$dbg_gitcontact_dir = File.expand_path '../gitcontacts/lib', ''
$LOAD_PATH << $dbg_gitcontact_dir unless !Dir.exist?($dbg_gitcontact_dir) || $LOAD_PATH.include?($dbg_gitcontact_dir)
$dbg_gitdb_dir = File.expand_path '../gitdb/lib', ''
$LOAD_PATH << $dbg_gitdb_dir unless !Dir.exist?($dbg_gitdb_dir) || $LOAD_PATH.include?($dbg_gitdb_dir)

require 'sinatra'
require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/config_file"
require "rack/session/moneta"
require 'json'
require 'gitcontacts'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  # load configration
  config_file "config.yml"

  # before each request
  before do
    # TODO: a pretty way to get request json
    @body = JSON.parse request.body.read, { symbolize_names: true }
    content_type 'application/json'
    status 200
    @return_message = {}
  end

  class Hash
    def to_json
      JSON.generate self
    end
  end

  # routes
  require_relative 'routes/contacts'
  require_relative 'routes/card'
  require_relative 'routes/user'
  require_relative 'routes/request'

end
