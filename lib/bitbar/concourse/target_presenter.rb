module Bitbar
  module Concourse
    class TargetPresenter
      def initialize(target)
        raise 'Target must not be nil' if target.nil?
        @target = target
      end

      def to_s
        if success?
          '✅  Flintstone CI | color=green'
        else
          '❌  Flintstone CI | color=red'
        end
      end

      def success?
        @target.pipelines.delete_if do |pipeline|
          pipeline.jobs.delete_if do |job|
            if job.latest_build
              job.latest_build.success?
            else
              true
            end
          end.empty?
        end.empty?
      end
    end
  end
end
