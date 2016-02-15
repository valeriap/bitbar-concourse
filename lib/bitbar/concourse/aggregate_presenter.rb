module Bitbar
  module Concourse
    class AggregatePresenter
      def initialize(builds, target_name = nil)
        @builds = Array(builds.dup)
        @target_name = target_name
      end

      def to_s
        if success?
          "✅  #{@target_name} | color=green"
        else
          "❌  #{@target_name} | color=red"
        end
      end

      def success?
        @builds.delete_if do |build|
          build.success?
        end.empty?
      end
    end
  end
end
