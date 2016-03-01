require 'spec_helper'

module Bitbar
  module Concourse
    describe BuildPresenter do
      subject do
        BuildPresenter.new(build)
      end

      context 'when build time is below a minute' do
        let(:build) do
          b = Object.new
          allow(b).to receive(:start_time).and_return(Time.at(23))
          allow(b).to receive(:end_time).and_return(Time.at(42))
          b
        end

        describe '#elapsed_time' do
          it 'returns seconds as is' do
            expect(subject.elapsed_time).to eq('19 seconds')
          end
        end
      end

      context 'when build time is exactly one minute' do
        let(:build) do
          b = Object.new
          allow(b).to receive(:start_time).and_return(Time.at(123))
          allow(b).to receive(:end_time).and_return(Time.at(183))
          b
        end

        describe '#elapsed_time' do
          it 'returns seconds as is' do
            expect(subject.elapsed_time).to eq('one minute')
          end
        end
      end
    end
  end
end
