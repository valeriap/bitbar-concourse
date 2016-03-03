# frozen_string_literal: true
require 'slack-notifier'

module Concourse
  module Slack
    class BuildNotifier
      def initialize(webhook_uri, username: 'Concourse', channel:)
        @notifier = ::Slack::Notifier.new(webhook_uri)
        @notifier.username = username
        @notifier.channel = channel
      end

      #
      # deliver a notification for each build
      #
      def deliver(changes)
        Array(changes).each do |change|
          begin
            @notifier.ping(change.to_s)
          rescue => e
            warn "Error: #{e.message}"
          end
        end
      end
    end
  end
end
