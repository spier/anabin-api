require 'grape'
require 'grape-swagger'

require_relative './Anabin'

module API
  class Root < Grape::API
    mount API::Anabin
    add_swagger_documentation :hide_documentation_path => true
  end
end