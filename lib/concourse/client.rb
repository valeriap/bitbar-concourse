# frozen_string_literal: true
require 'uri'
require 'open-uri'
require 'net/https'

module Concourse
  class Client
    API_BASE_PATH = '/api/v1/'

    attr_reader :base_uri

    def initialize(base_uri, username, password)
      @base_uri = URI(base_uri) + API_BASE_PATH
      @username = username
      @password = password
    end

    def get(path)
      path = path[1..-1] if path.start_with?('/')
      url = @base_uri + path

      open(url, http_opts).read
    end

    private

    def http_opts
      {
        http_basic_authentication: [@username, @password],
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
        open_timeout: 5
      }
    end
  end
end
