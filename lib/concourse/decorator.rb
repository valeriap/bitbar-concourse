module Concourse
  module ToStringDecorator
    def to_s(format = :short)
      self.class.name.split('::').last.downcase.to_s.tap do |result|
        result << " #{name}" unless name.to_s.strip.empty?
        if format != :short && respond_to?(:parent) && parent.method(:to_s).parameters.any?
          result << " of #{parent.to_s(format)}"
        end
      end
    end
  end
end
