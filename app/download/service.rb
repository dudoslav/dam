require 'securerandom'

require_relative 'download'

module DAM
  module Download
    class Service
      def initialize(download_folder)
        @download_folder = download_folder
        @downloads = {}
      end

      def download(uri)
        id = SecureRandom.urlsafe_base64(4)
        @downloads[id] = Download.new(uri, @download_folder)
        @downloads[id].start

        { id: id }
      end

      def status(id)
        d = @downloads[id]
        raise ArgumentError, "Cannot find download ##{id}" unless d

        { id: id }.merge d.status
      end

      def status_all()
        @downloads.map { |k, v| { id: k }.merge v.status }
      end

      def stop(id)
        d = @downloads.delete(id)
        raise ArgumentError, "Cannot stop not existing download ##{id}" unless d

        d.stop
      end
    end
  end
end
