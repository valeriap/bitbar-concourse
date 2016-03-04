require 'yaml/store'
require 'pstore_adapter'

module Concourse
  module Slack
    class Store < SimpleDelegator
      def initialize(file_path)
        super PStoreAdapter.new(YAML::Store.new(file_path))
      end
    end
  end
end
