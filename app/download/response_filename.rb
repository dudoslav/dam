require 'net/http'

module DAM
  module Download
    module ResponseFilename
      refine Net::HTTPResponse do
        def filename
          return unless @header['content-disposition']

          @header['content-disposition']
            .map { |h| h.match(/filename=(\"?)(.+)\1/)[2] }
            .compact
            .first
        end
      end
    end
  end
end
