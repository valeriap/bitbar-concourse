# frozen_string_literal: true

module Concourse
  module Slack
    Change = Struct.new(:build, :previous_state) do
      def to_s
        "Build #{build.name} of #{build.job.name} [#{build.status}](#{build.url})"
      end
    end

    Addition = Struct.new(:build) do
      def to_s
        "New build #{build.name} of #{build.job.name} [#{build.status}](#{build.url})"
      end
    end

    Removal = Struct.new(:name) do
      def to_s
        "Build #{name} was removed"
      end
    end

    class Repository
      def initialize(store)
        @store = store
      end

      def update(builds)
        result = builds.map do |build|
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

        removed = @store.keys - builds.map { |build| build.url.to_s }

        removed.each do |removed_url|
          result << Removal.new(removed_url)
          @store.delete(removed_url)
        end

        result
      end
    end
  end
end
