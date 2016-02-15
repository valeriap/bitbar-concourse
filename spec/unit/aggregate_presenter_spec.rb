require 'spec_helper'

module Bitbar
  module Concourse
    describe AggregatePresenter do
      let(:build_green){
        double(::Concourse::Build)
      }

      let(:build_red){
        double(::Concourse::Build)
      }

      before do
        allow(build_green).to receive(:success?).and_return(true)
        allow(build_red).to receive(:success?).and_return(false)
      end

      context 'when all jobs of all pipelines are green' do
        subject {
          AggregatePresenter.new([build_green, build_green])
        }

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
        subject {
          AggregatePresenter.new([build_green, build_red])
        }

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
        subject {
          AggregatePresenter.new([build_red, build_red])
        }

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
