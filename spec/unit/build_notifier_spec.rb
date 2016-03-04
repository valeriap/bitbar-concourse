# frozen_string_literal: true
require 'spec_helper'
require 'concourse/slack'

module Concourse
  module Slack
    describe BuildNotifier do
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

      context 'when there was a change' do
        let(:changes) { ['foo'] }

        describe '#deliver' do
          it 'delivers the message' do
            allow_any_instance_of(::Slack::Notifier).to receive(:ping) do |_notifier, msg|
              expect(msg).to eq('foo')
            end

            subject.deliver(changes)
          end
        end
      end
    end
  end
end
