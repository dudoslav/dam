require_relative '../../../app/api'
require 'rack/test'

module DAM
  RSpec.describe API do
    include Rack::Test::Methods

    def expect_json_response(expectation)
      expect(JSON.parse(last_response.body)).to expectation
    end

    def app
      API.new(download_service: download_service)
    end

    let(:download_service) { instance_double('DAM::DownloadService') }

    describe 'POST /downloads' do
      context 'when the download successfully starts' do
        let(:download) { { 'uri' => 'http://www.google.com' } }

        before do
          allow(download_service).to receive(:download)
            .with(download)
            .and_return(DownloadResult.new(true, 1, nil))
        end

        it 'returns the download id' do
          post '/downloads', JSON.generate(download)

          expect_json_response include('id' => 1)
        end

        it 'responds with a 200 (OK)' do
          post '/downloads', JSON.generate(download)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the download fails to start' do
        let(:download) { { 'uri' => 'http://www.google.com' } }

        before do
          allow(download_service).to receive(:download)
            .with(download)
            .and_return(DownloadResult.new(false, 1,
                                           'File cannot be downloaded'))
        end

        it 'returns an error message' do
          post '/downloads', JSON.generate(download)

          expect_json_response include('error' => 'File cannot be downloaded')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/downloads', JSON.generate(download)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /downloads/:id' do
      context 'when download exists with given id' do
        it 'returns the download info as JSON'
        it 'responds with a 200 (OK)'
      end

      context 'when there are no downloads with given id' do
        it 'returns an empty array of JSON' do
          get '/downloads/12345'

          expect_json_response include('error' =>
                                       'Download with given id does not exist')
        end
        
        it 'responds with 404 (Not found)'
      end
    end
  end
end
