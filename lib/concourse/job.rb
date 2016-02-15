module Concourse
  #
  # A job belongs to a pipeline
  # A job has many builds
  # A job has one latest_build
  #
  class Job
    attr_reader :pipeline

    def initialize(pipeline, info)
      @pipeline = pipeline
      @info = info
    end

    def name
      @info['name']
    end

    def to_s
      "#{self.class.name.split('::').last.downcase} #{name} of #{pipeline}"
    end

    def builds
      JSON.parse(@pipeline.get("/#{name}/builds")).map do |build|
        Build.new(self, build)
      end
    end

    def latest_build
      builds.first
    end

    def url
      @pipeline.url + @info['url']
    end
  end
end
