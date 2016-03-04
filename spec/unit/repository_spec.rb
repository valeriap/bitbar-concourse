# frozen_string_literal: true
require 'spec_helper'
require 'pathname'
require 'concourse/slack'

module Concourse
  module Slack
    describe Repository do
      let(:store){Hash.new}

      subject { Repository.new(store) }

      context 'when there are no previous builds' do
        let(:builds){[]}

        describe '#update' do
          it 'returns a valid build' do
            expect(subject.update(builds)).to eq([])
          end
        end
      end

      context 'when there were previous builds' do
        before do
          allow(build).to receive(:url).and_return('http://example.com')
          allow(build).to receive(:status).and_return('failed')
          allow(build).to receive(:name).and_return('42')
          allow(build).to receive(:job).and_return(job)
          allow(job).to receive(:name).and_return('run-unit-tests')
        end

        let(:job){double(Job)}
        let(:build){double(Build)}
        let(:builds){[build]}

        context 'when a build was added' do
          describe '#update' do
            it 'returns an addition' do
              allow(store).to receive(:[])

              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('New build 42 of run-unit-tests [failed](http://example.com)')
            end
          end
        end

        context 'when a build remains unchanged' do
          describe '#update' do
            it 'returns no changes' do
              allow(store).to receive(:[]).and_return('failed')
              changes = subject.update(builds)
              expect(changes).to be_empty
            end
          end
        end

        context 'when a build changed' do
          describe '#update' do
            it 'returns an addition' do
              allow(store).to receive(:[]).and_return('succeeded')

              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('Build 42 of run-unit-tests [failed](http://example.com)')
            end
          end
        end

        context 'when a build was removed' do
          describe '#update' do
            it 'returns a removal' do
              store['http://example.com'] = 'failed'
              store['http://example.com/42'] = 'removed'

              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('Build http://example.com/42 was removed')
            end
          end
        end
      end
    end
  end
end
