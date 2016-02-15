require 'spec_helper'

module Bitbar
  module Concourse
    describe TargetPresenter do
      let(:target){
        double(::Concourse::Target)
      }

      subject {
        TargetPresenter.new(target)
      }

      context 'when all jobs of all pipelines are green' do
        describe '#elapsed_time' do
          it 'returns presents the target as green' do
            expect(subject.to_s).to include('color=green')
          end
        end
      end
    end
  end
end
