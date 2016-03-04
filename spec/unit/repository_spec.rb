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
          allow(build).to receive(:url).and_return('http://example.com/job/run-unit-tests/builds/42')
          allow(build).to receive(:status).and_return('failed')
          allow(build).to receive(:name).and_return('42')
          allow(build).to receive(:to_s).and_return('build 42')

          allow(build).to receive(:job).and_return(job)

          allow(job).to receive(:name).and_return('run-unit-tests')
          allow(job).to receive(:url).and_return('http://example.com/job/run-unit-tests')
          allow(job).to receive(:to_s).and_return('test_job')
        end

        let(:job){double(Job)}
        let(:build){double(Build)}
        let(:builds){[build]}

        context 'and a new build was added, ' do
          describe '#update' do
            it 'returns an addition' do
              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('New test_job: build 42 [failed](http://example.com/job/run-unit-tests/builds/42)')
            end
          end
        end

        context 'and an existing build remains unchanged, ' do
          describe '#update' do
            it 'returns no changes' do
              store['http://example.com/job/run-unit-tests'] = build

              changes = subject.update(builds)
              expect(changes).to be_empty
            end
          end
        end

        context 'and an existing build changed, ' do
          describe '#update' do
            let(:previous_build){double(Build)}

            it 'returns an addition' do
              allow(previous_build).to receive(:status).and_return('succeeded')
              store[build.job.url] = previous_build

              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('test_job: build 42 [failed](http://example.com/job/run-unit-tests/builds/42)')
            end
          end
        end

        context 'when a build was removed' do
          describe '#update' do
            let(:other_build){double(Build)}
            let(:other_job){double(Job)}

            it 'returns a removal' do
              allow(other_build).to receive(:status).and_return('failed')
              allow(other_build).to receive(:job).and_return(other_job)
              allow(other_job).to receive(:to_s).and_return('other_job')

              store['http://example.com/job/run-unit-tests'] = build
              store['http://example.com/job/run-integration-tests'] = other_build

              changes = subject.update(builds)

              expect(changes).to_not be_empty
              expect(changes.size).to eq(1)
              expect(changes.first.to_s).to eq('other_job was removed')
            end
          end
        end
      end
    end
  end
end
