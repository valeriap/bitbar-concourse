# frozen_string_literal: true
module Concourse
  module Slack
    Change = Struct.new(:current_build, :previous_build) do
      def to_s
        "#{current_build.job}: #{current_build} [#{current_build.status}](#{current_build.url})"
      end
    end

    Addition = Struct.new(:new_build) do
      def to_s
        "New #{new_build.job}: #{new_build} [#{new_build.status}](#{new_build.url})"
      end
    end

    Removal = Struct.new(:previous_build) do
      def to_s
        "#{previous_build.job} was removed"
      end
    end

    class Repository
      def initialize(store)
        @store = store
      end

      def update(current_builds)
        result = current_builds.map do |current_build|
          begin
            previous_build = @store[current_build.job.url.to_s]

            if previous_build.nil?
              Addition.new(current_build)
            else
              Change.new(current_build, previous_build) if current_build.status != previous_build.status
            end
          ensure
            @store[current_build.job.url.to_s] = current_build
          end
        end.compact

        removed = @store.keys - current_builds.map { |current_build| current_build.job.url.to_s }

        removed.each do |removed_url|
          previous_build = @store.delete(removed_url)
          result << Removal.new(previous_build)
        end

        result
      end
    end
  end
end
