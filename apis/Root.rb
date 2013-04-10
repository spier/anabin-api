require 'grape'
require 'grape-swagger'

require_relative './Anabin'

module API
  class Root < Grape::API
    mount API::Anabin
    add_swagger_documentation
  end
end