require 'spec_helper'

module Concourse
  describe Target do
    let(:api) { 'http://10.155.248.166:8080' }
    let(:user) { 'admin' }
    let(:password) { 'admin' }
    let(:client) do
      double(Client)
    end

    subject do
      Target.new(client, 'test')
    end

    context 'when target is available' do
      before do
        fixture = Pathname(__dir__).parent / 'fixtures/pipelines/bits-service.json'
        allow(client).to receive(:get).and_return(File.read(fixture))
      end

      describe '#pipelines' do
        it 'returns multiple pipelines' do
          expect(subject.pipelines).to_not be_empty
        end
      end
    end

    describe '#to_s' do
      it 'no arg returns the short form' do
        expect(subject.to_s).to eq('target test')
      end

      it ':short returns the short form' do
        expect(subject.to_s(:short)).to eq('target test')
      end

      it ':long returns the long form' do
        expect(subject.to_s(:long)).to eq('target test')
      end
    end

    context 'when target has no name' do
      subject do
        Target.new(client)
      end

      describe '#to_s' do
        it 'no arg returns the short form' do
          expect(subject.to_s).to eq('target')
        end

        it ':short returns the short form' do
          expect(subject.to_s(:short)).to eq('target')
        end

        it ':long returns the long form' do
          expect(subject.to_s(:long)).to eq('target')
        end
      end
    end
  end
end
