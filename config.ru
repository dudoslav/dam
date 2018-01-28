require_relative 'app/api'
require_relative 'app/ui'

run Rack::Cascade.new [DAM::API, DAM::UI]
