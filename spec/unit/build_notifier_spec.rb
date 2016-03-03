require 'spec_helper'
require 'concourse/slack'

module Concourse
  module Slack
    describe BuildNotifier do
      let(:job_with_failed_build) do
        double(Job).tap do |job|
          allow(job).to receive(:name) { 'test job' }
        end
      end

      let(:failed_build) do
        double(Build).tap do |failed_build|
          allow(failed_build).to receive(:name) { '#0' }
          allow(failed_build).to receive(:job) { job_with_failed_build }
          allow(failed_build).to receive(:status) { 'failed' }
          allow(failed_build).to receive(:url) { 'http://ci.example.com' }
        end
      end

      subject do
        BuildNotifier.new('http://anything', username: 'username', channel: '#channel')
      end

      shared_examples 'silent' do
        describe '#deliver' do
          it 'does not deliver a message' do
            subject.deliver(builds)
          end
        end
      end

      context 'when builds is nil' do
        it_behaves_like 'silent' do
          let(:builds) { nil }
        end
      end

      context 'when builds is empty' do
        it_behaves_like 'silent' do
          let(:builds) { [] }
        end
      end

      context 'when there is a failed build' do
        let(:builds) { failed_build }

        describe '#deliver' do
          it 'delivers the message' do
            allow_any_instance_of(::Slack::Notifier).to receive(:ping) do |_notifier, msg|
              expect(msg).to eq('Build #0 of test job [failed](http://ci.example.com)')
            end

            subject.deliver(builds)
          end
        end
      end
    end
  end
end
