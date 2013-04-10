require 'sinatra'
# require 'grape'

require './apis/Root'

class Web < Sinatra::Base
  get '/' do
    File.read(File.join('public', 'index.html'))
  end
end

use Rack::Session::Cookie
run Rack::Cascade.new [API::Root, Web]