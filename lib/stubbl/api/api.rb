# coding: utf-8
require 'sinatra'

module Stubbl
  module API
    class App < Sinatra::Base

      get '/' do
        "Hello World"
      end
    

    end
  end
end
