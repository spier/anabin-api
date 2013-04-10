# require 'sinatra'
# require 'grape'

require './apis/Root'

use Rack::Session::Cookie
run Rack::Cascade.new [API::Root]