require 'sinatra/base'

module DAM
  class UI < Sinatra::Base
    set :public_folder, Proc.new { File.join(root,"../public") }
    enable :static

    get '/' do
      send_file 'public/index.html'
    end
  end
end
