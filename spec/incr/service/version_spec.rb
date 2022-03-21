require 'spec_helper'

require 'sem_version'

describe Incr::Service::Version do
  describe '.increment_segment' do
    context 'with a SemVersion object' do
      let(:version) { SemVersion.new('1.0.0') }

      it 'should increment the major segment' do
        expected = '2.0.0'
        result = Incr::Service::Version.increment_segment(version, 'major')

        expect(result.to_s).to eql(expected)
      end

      it 'should increment the minor segment' do
        expected = '1.1.0'
        result = Incr::Service::Version.increment_segment(version, 'minor')

        expect(result.to_s).to eql(expected)
      end

      it 'should increment the patch segment' do
        expected = '1.0.1'
        result = Incr::Service::Version.increment_segment(version, 'patch')

        expect(result.to_s).to eql(expected)
      end
    end

    context 'with a version string' do
      let(:version) { '1.0.0' }

      it 'should throw an error' do
        expect {
          Incr::Service::Version.increment_segment(version, 'patch')
        }.to raise_error(NoMethodError)
      end
    end

    context 'with an unknown segment' do
      let(:version) { SemVersion.new('1.0.0') }

      it 'should not do anything' do
        expected = '1.0.0'
        result = Incr::Service::Version.increment_segment(version, 'foobar')

        expect(result.to_s).to eql(expected)
      end
    end
  end
end
