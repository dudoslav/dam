require 'sinatra/base'
require 'sinatra/config_file'
require 'json'

require_relative 'download/service'

module DAM
  class API < Sinatra::Base
    register Sinatra::ConfigFile

    config_file '../config/config.yml'
    config_file '/etc/dam.yml' if File.file? '/etc/dam.yml'

    def initialize(download_service: Download::Service.new(settings.download_folder))
      @download_service = download_service
      super()
    end

    post '/downloads' do
      download = JSON.parse(request.body.read)
      @download_service.download(download['uri']).to_json
    end

    get '/downloads' do
      @download_service.status_all.to_json
    end

    get '/downloads/:id' do
      begin
        @download_service.status(params['id']).to_json
      rescue ArgumentError => e
        status 404
        { error: e.message }.to_json
      end
    end

    delete '/downloads/:id' do
      begin
        @download_service.stop(params['id'])

        { status: 'stopped' }.to_json
      rescue ArgumentError => e
        status 404
        { error: e.message }.to_json
      end
    end
  end
end
