require 'slack-notifier'

module Concourse
  module Slack
    class BuildNotifier
      def initialize(webhook_uri, username: 'Concourse', channel: )
        @notifier = ::Slack::Notifier.new(webhook_uri)
        @notifier.username = username
        @notifier.channel = channel
      end

      #
      # deliver a notification for each build
      #
      def deliver(builds)
        Array(builds).each do |build|
          begin
            @notifier.ping("Build #{build.name} of #{build.job.name} [#{build.status}](#{build.url})")
          rescue
            warn "Error: #{$!.message}"
          end
        end
      end
    end
  end
end
