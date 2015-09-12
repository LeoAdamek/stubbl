# coding: utf-8
require 'stubbl/api/webhooks'

class Stubbl::API::App < Grape::API
  # This API speaks JSON. 😄
  format :json
  
  mount Stubbl::API::Webhooks
end
