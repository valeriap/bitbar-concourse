require 'spec_helper'

module Bitbar
  module Concourse
    describe TargetPresenter do
      let(:target){
        double(::Concourse::Target)
      }

      let(:pipeline){
        double(::Concourse::Pipeline)
      }

      let(:job_0){
        double(::Concourse::Job)
      }

      let(:job_1){
        double(::Concourse::Job)
      }

      let(:build_green){
        double(::Concourse::Build)
      }

      let(:build_red){
        double(::Concourse::Build)
      }

      subject {
        TargetPresenter.new(target)
      }

      before do
        allow(target).to receive(:pipelines).and_return([pipeline])
        allow(pipeline).to receive(:jobs).and_return([job_0, job_1])
        allow(build_green).to receive(:success?).and_return(true)
        allow(build_red).to receive(:success?).and_return(false)
      end

      context 'when all jobs of all pipelines are green' do
        before do
          allow(job_0).to receive(:latest_build).and_return(build_green)
          allow(job_1).to receive(:latest_build).and_return(build_green)
        end

        describe '#to_s' do
          it 'returns presents the target as green' do
            expect(subject.to_s).to include('color=green')
          end
        end

        describe '#success?' do
          it 'returns true' do
            expect(subject.success?).to be true
          end
        end
      end

      context 'when one job of a pipelines is red' do
        before do
          allow(job_0).to receive(:latest_build).and_return(build_green)
          allow(job_1).to receive(:latest_build).and_return(build_red)
        end

        describe '#to_s' do
          it 'returns presents the target as green' do
            expect(subject.to_s).to include('color=red')
          end
        end

        describe '#success?' do
          it 'returns true' do
            expect(subject.success?).to be false
          end
        end
      end

      context 'when all jobs of all pipelines are red' do
        before do
          allow(job_0).to receive(:latest_build).and_return(build_red)
          allow(job_1).to receive(:latest_build).and_return(build_red)
        end

        describe '#to_s' do
          it 'returns presents the target as green' do
            expect(subject.to_s).to include('color=red')
          end
        end

        describe '#success?' do
          it 'returns true' do
            expect(subject.success?).to be false
          end
        end
      end
    end
  end
end
