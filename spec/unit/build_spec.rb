require 'spec_helper'
require 'json'

module Concourse
  describe Build do
    let(:job) do
      double(Job)
    end

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:build_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds/12.json')
    end

    describe '#new' do
      it 'returns a valid build' do
        allow(job).to receive(:url).and_return('')

        build = Build.new(job, build_json)
        expect(build).to_not be_nil
        expect(build.name).to eq('12')

        expect(build.status).to eq('succeeded')
        expect(build.url).to eq('/pipelines/bits-service/jobs/CATs-with-bits/builds/12')
        expect(build.start_time.to_s).to eq('2016-02-12 17:36:55 +0100')
        expect(build.end_time.to_s).to eq('2016-02-12 17:54:49 +0100')
      end
    end
  end
end
