require 'sinatra'
require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/config_file"
require "rack/session/moneta"
require 'json'
require 'gitcontacts'

class Hash
  def to_json
    JSON.generate self
  end
end

# session control
use Rack::Session::Moneta, store: Moneta.new(:Redis, expires: 60 * 60 * 24 * 7)

class App < Sinatra::Base
  # before each request
  before do
    # TODO: a pretty way to get request json
    begin
      @body = JSON.parse request.body.read, { symbolize_names: true }
    rescue => e
      puts "Error: [ #{e} ]"
    end
    content_type 'application/json'
    status 200
    @return_message = {}
  end

  # routes
  require 'api/routes/contacts'
  require 'api/routes/card'
  require 'api/routes/user'
  require 'api/routes/request'
end
