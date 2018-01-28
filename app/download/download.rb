require 'uri'
require 'open-uri'

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
          d = open(@uri,
            content_length_proc: lambda { |s| @size = s },
            progress_proc: lambda { |p| @current = p })

          IO.copy_stream(d, @path)
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
          current: @current }
      end
    end
  end
end
