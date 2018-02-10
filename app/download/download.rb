require 'uri'
require 'net/http'

module DAM
  module Download
    class Download
      def initialize(uri, download_folder)
        @uri = URI.parse(uri)
        @name = File.basename(@uri.path)
        @path = File.join(download_folder, @name)
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
            else
              @size = resp.header['content-length']
              f = File.open(@path, 'w')
              begin
                resp.read_body do |segment|
                  @current = (@current || 0) + segment.length
                  f.write(segment)
                end
              ensure
                f.close
              end
            end
          end
        end
      rescue StandardError => e
        @error = e.message
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
