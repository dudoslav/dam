require 'uri'
require 'net/http'

require_relative 'response_filename'

module DAM
  module Download
    class Download
      using ResponseFilename

      def initialize(uri, download_folder)
        @uri = URI.parse(uri)
        @download_folder = download_folder
      end

      def start
        @thread = Thread.new do
          fetch @uri
        end
      end

      def fetch(uri, limit = 10)
        raise ArgumentError, 'Too many HTTP redirects' if limit == 0

        Net::HTTP.start(uri.host) do |http|
          http.request_get(uri.path) do |resp|
            case resp
            when Net::HTTPRedirection then
              fetch(resp['location'], limit - 1)
            when Net::HTTPSuccess then
              puts 'before response_ok'
              response_ok resp
              puts 'after response_ok'
            end
          end
        end
      rescue StandardError => e
        @error = e.message
      end

      def response_ok(response)
        @size = response.header['content-length']
        @name = response.filename || File.basename(@uri.path)
        @path = File.join(@download_folder, @name)

        download_to_folder response
      end

      def download_to_folder(response)
        f = File.open(@path, 'w')
        begin
          response.read_body do |segment|
            @current = (@current || 0) + segment.length
            f.write(segment)
          end
        ensure
          f.close
        end
      end

      def stop
        @thread.kill if @thread
      end

      def status
        { uri: @uri,
          name: @name,
          path: @path,
          size: @size,
          current: @current,
          error: @error }
      end
    end
  end
end
