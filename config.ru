require './api'

# session control
use Rack::Session::Moneta, store: Moneta.new(:Redis, expires: 60 * 60 * 24 * 7)

run App