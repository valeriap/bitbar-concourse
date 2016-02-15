module Bitbar
  module Concourse
    class TargetPresenter
      def initialize(target)
        raise 'Target must not be nil' if target.nil?
        @target = target
      end

      def to_s
        '✅  Flintstone CI | color=green'
      end
    end
  end
end
