require 'sinatra/base'
require 'json'

module DAM
  class API < Sinatra::Base
    post '/downloads' do
      JSON.generate('id' => 2)
    end

    get '/downloads/:id' do
      JSON.generate([])
    end
  end
end
