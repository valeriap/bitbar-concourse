require 'uri'
require 'json'
require 'open-uri'
require 'net/https'

module Concourse
  #
  # A target has many pipelines
  #
  class Target
    def initialize(client)
      @client = client
    end

    def pipelines
      JSON.parse(get).map do |json|
        Pipeline.new(self, json)
      end
    end

    def get(path = '')
      @client.get('pipelines' + path)
    end

    def url
      @client.base_uri
    end
  end
end
