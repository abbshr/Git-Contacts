require './api'

# session control
use Rack::Session::Moneta, store: Moneta.new(:Redis, expires: 60 * 60 * 24 * 7)

register Sinatra::ConfigFile

# load configration
config_file "config.yml"

run App