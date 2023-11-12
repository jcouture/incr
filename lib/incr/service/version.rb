require 'sem_version'

module Incr
  module Service
    class Version
      SEGMENT_OPERATIONS = {
        'major' => ->(v, _) { v.major += 1; v.minor = 0; v.patch = 0; v.prerelease = nil },
        'minor' => ->(v, _) { v.minor += 1; v.patch = 0; v.prerelease = nil },
        'patch' => ->(v, _) { v.patch += 1; v.prerelease = nil },
        'prerelease' => ->(v, id) { handle_prerelease(v, id) },
      }.freeze
    
      def self.increment_segment(version, segment, identifier = nil)
        incremented_version = version.clone
    
        operation = SEGMENT_OPERATIONS[segment]
        raise ArgumentError, "Unknown segment: #{segment}" unless operation
    
        operation.call(incremented_version, identifier)
    
        incremented_version
      end
    
      def self.handle_prerelease(version, identifier)
        if version.prerelease.nil?
          version.patch += 1
          identifier = 'alpha' if identifier.nil?
          version.prerelease = "#{identifier}.1"
        else
          version.prerelease = increment_prerelease(version.prerelease, identifier)
        end
      end
    
      def self.increment_prerelease(value, identifier)
        parts = value.split('.')
        parts[-1] = identifier.nil? ? parts[-1].to_i + 1 : 1
        parts[0] = identifier if identifier
        parts.join('.')
      end
    end
  end
end
