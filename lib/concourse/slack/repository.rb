# frozen_string_literal: true
require 'yaml/store'

module Concourse
  module Slack
    Change = Struct.new(:build, :previous_state) do
      def to_s
        "Build #{build.name} of #{build.job.name} changed from #{previous_state} to [#{build.status}](#{build.url})"
      end
    end

    Addition = Struct.new(:build) do
      def to_s
        "Build #{build.name} of #{build.job.name} was added as [#{build.status}](#{build.url})"
      end
    end

    class Repository
      def initialize(file_path)
        @store = YAML::Store.new(file_path)
      end

      #
      # returns builds that have changed, were added or removed since
      # this method was last called
      #
      def update(builds)
        @store.transaction do
          builds.map do |build|
            begin
              previous_state = @store[build.url.to_s]

              if previous_state.nil?
                Addition.new(build)
              else
                Change.new(build, previous_state) if build.status != previous_state
              end
            ensure
              @store[build.url.to_s] = build.status
            end
          end.compact

          # TODO: FInd removed builds
        end
      end
    end
  end
end
