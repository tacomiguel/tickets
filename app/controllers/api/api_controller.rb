class Api::ApiController < ActionController::API
  include TokenAuthentication
  include Pagy::Backend
end
