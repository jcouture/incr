require 'spec_helper'
require 'sem_version'

describe Incr::Service::Version do
  describe '.increment_segment' do
    context 'with a SemVersion object' do
      let(:version) { SemVersion.new('1.2.4') }

      it 'increments the major segment and resets the minor and patch segments' do
        expected = '2.0.0'
        result = Incr::Service::Version.increment_segment(version, 'major')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the minor segment and resets the patch segment' do
        expected = '1.3.0'
        result = Incr::Service::Version.increment_segment(version, 'minor')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the patch segment' do
        expected = '1.2.5'
        result = Incr::Service::Version.increment_segment(version, 'patch')
        expect(result.to_s).to eql(expected)
      end

      it 'does not increment if segment is not recognized' do
        expect {
          Incr::Service::Version.increment_segment(version, 'unknown')
        }.to raise_error(ArgumentError)
      end
    end

    context 'with a version string' do
      let(:version) { '1.0.0' }

      it 'throws an error' do
        expect {
          Incr::Service::Version.increment_segment(version, 'patch')
        }.to raise_error(NoMethodError)
      end
    end

    context 'without a prerelease version' do
      let(:version) { SemVersion.new('1.0.0') }

      it 'increments the prerelease segment' do
        expected = '1.0.1-alpha.1'
        result = Incr::Service::Version.increment_segment(version, 'prerelease', 'alpha')
        expect(result.to_s).to eql(expected)
      end
    end
    
    context 'with a prerelease version' do
      let(:version) { SemVersion.new('1.0.0-alpha.1') }

      it 'increments the prerelease segment' do
        expected = '1.0.0-alpha.2'
        result = Incr::Service::Version.increment_segment(version, 'prerelease')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the prerelease segment with a custom identifier' do
        expected = '1.0.0-rc.1'
        result = Incr::Service::Version.increment_segment(version, 'prerelease', 'rc')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the prerelease segment with a custom identifier and resets the prerelease segment' do
        expected = '1.0.0-rc.1'
        result = Incr::Service::Version.increment_segment(version, 'prerelease', 'rc')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the prerelease segment with a custom identifier and resets the prerelease segment' do
        expected = '1.0.0-rc.1'
        result = Incr::Service::Version.increment_segment(version, 'prerelease', 'rc')
        expect(result.to_s).to eql(expected)
      end

      it 'increments the minor segment' do
        expected = '1.1.0'
        result = Incr::Service::Version.increment_segment(version, 'minor')
        expect(result.to_s).to eql(expected)
      end

      it 'handles empty custom identifier' do
        expect { Incr::Service::Version.increment_segment(version, 'prerelease', '') }.to raise_error(ArgumentError)
      end
    end
  end
end
