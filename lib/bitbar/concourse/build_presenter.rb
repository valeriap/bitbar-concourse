module Bitbar
  # derived from http://stackoverflow.com/a/195894
  module RelativeTime
    def to_relative
      a = (Time.now - self).to_i

      case a
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then a.to_s + ' seconds ago'
      when 60..119 then 'a minute ago' # 120 = 2 minutes
      when 120..3540 then (a / 60).to_i.to_s + ' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82_800 then ((a + 99) / 3600).to_i.to_s + ' hours ago'
      when 82_801..172_000 then 'a day ago' # 86400 = 1 day
      when 172_001..518_400 then ((a + 800) / (60 * 60 * 24)).to_i.to_s + ' days ago'
      when 518_400..1_036_800 then 'a week ago'
      else ((a + 180_000) / (60 * 60 * 24 * 7)).to_i.to_s + ' weeks ago'
      end
    end
  end

  module Concourse
    class BuildPresenter
      def initialize(build)
        fail 'Build must not be nil' if build.nil?
        @build = build
      end

      def to_s
        icon = @build.success? ? '✅' : '❌'

        lines = [
          "#{icon}  #{@build.job_name} - build ##{@build.name} | href=#{@build.url}",
          "finished #{end_time}; took #{elapsed_time}"
        ]

        next_build = @build.job.next_build

        if next_build
          started_at = next_build.start_time.extend(RelativeTime).to_relative
          lines << "next build (##{next_build.name}) started #{started_at} | href=#{next_build.url}"
        end

        lines.join("\n")
      end

      def elapsed_time
        case difference = @build.end_time.to_i - @build.start_time.to_i
        when 0..59
          "#{difference} seconds"
        when 60..80
          'one minute'
        when 81..(60 * 25)
          "#{difference / 60} minutes"
        when (60 * 26)..(60 * 35)
          'about half an hour'
        else
          "#{difference}s"
        end
      end

      def end_time
        @build.end_time.extend(RelativeTime).to_relative if @build.end_time
      end

      def success?
        @build.success?
      end
    end
  end
end
