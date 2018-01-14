require 'rack/test'
require 'json'

require_relative '../../app/api'

module DAM
  describe 'DAM API' do
    include Rack::Test::Methods

    def app
      DAM::API.new
    end

    def post_download(download)
      post '/downloads', JSON.generate(download)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('id' => a_kind_of(Integer))
      download.merge(parsed)
    end

    it 'starts submitted download' do
      pending 'Need to save and start downloads'

      meme = post_download(
        'uri' => 'https://img-9gag-fun.9cache.com/photo/a7MLZpL_700b.jpg'
      )

      get "/downloads/#{meme['id']}"
      expect(last_response.status).to eq(200)

      download = JSON.parse(last_response.body)
      expect(download).to include('uri' => meme['uri'])
    end
  end
end
