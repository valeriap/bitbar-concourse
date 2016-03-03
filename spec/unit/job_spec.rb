require 'spec_helper'
require 'json'

module Concourse
  describe Job do
    let(:pipeline) do
      double(Pipeline)
    end

    let(:fixtures) do
      Pathname(__dir__).parent / 'fixtures'
    end

    let(:job_json) do
      JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json')
    end

    subject{Job.new(pipeline, job_json)}

    before do
      allow(pipeline).to receive(:url).and_return('http://example.com')
      allow(pipeline).to receive(:get).with('/CATs-with-bits').and_return(File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json'))
      allow(pipeline).to receive(:get).with('/CATs-with-bits/builds').and_return(File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits/builds.json'))
    end

    describe '#new' do
      it 'returns a valid job' do
        expect(subject).to_not be_nil
        expect(subject.name).to eq('CATs-with-bits')

        # TBD
        # expect(subject.group).to eq('bits-service')

        builds = subject.builds
        expect(builds).to_not be_empty
        expect(builds.size).to eq(12)

        build_9 = builds[9]
        expect(build_9).to_not be_nil
        expect(build_9.name).to eq('3')
      end

      context 'latest job is in started state' do
        let(:job_json) do
          JSON.parse File.read(fixtures / 'pipelines/bits-service/jobs/CATs-with-bits.json')
        end

        it 'has a latest finished build' do
          expect(subject.finished_build).to be
          expect(subject.finished_build.finished?).to be(true)
        end
      end

      describe '#to_s' do
        it 'no arg returns the short form' do
          expect(subject.to_s).to eq('job CATs-with-bits')
        end

        it ':short returns the short form' do
          expect(subject.to_s(:short)).to eq('job CATs-with-bits')
        end

        it ':long returns the long form' do
          allow(pipeline).to receive(:to_s).with(:long).and_return('pipeline foobar')
          expect(subject.to_s(:long)).to eq('job CATs-with-bits of pipeline foobar')
        end
      end
    end
  end
end
