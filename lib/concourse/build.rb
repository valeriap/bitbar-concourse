module Concourse
  #
  # A build belongs to a job
  #
  class Build
    def initialize(job, info)
      @job = job
      @info = info
    end

    def success?
      status == 'succeeded'
    end

    def changing?
      !!@info['next_build']
    end

    def url
      @job.url + @info['url']
    end

    def status
      @info['status']
    end

    def job_name
      @info['job_name']
    end

    def name
      @info['name']
    end

    def start_time
      Time.at(@info['start_time']) if @info['start_time']
    end

    def end_time
      Time.at(@info['end_time']) if @info['end_time']
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} #{name} of #{@job}"
    end
  end
end
