$dep_dir = '/home/ran/github/gitcontacts/lib'
$LOAD_PATH << $dep_dir unless $LOAD_PATH.include? $dep_dir
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
    # for dev test
    #session[:uid] = 'qwer'
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

  # for dev test
  get '/' do
    @return_message[:name] = 'Aizen'
    @return_message.to_json
  end

  # routes
  require_relative 'routes/contacts'
  require_relative 'routes/card'
  require_relative 'routes/user'
  require_relative 'routes/request'
  require_relative 'routes/invitation'

  not_found do
    { :errmsg => "NOT FOUND! may be this api hasn't been public now." }.to_json
  end
end
