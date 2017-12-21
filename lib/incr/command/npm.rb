require 'json'
require 'sem_version'

module Incr
  module Command
    class Npm
      PACKAGE_JSON_FILENAME = 'package.json'.freeze
      PACKAGE_LOCK_JSON_FILENAME = 'package-lock.json'.freeze

      def initialize(args)
        @segment = args[0]
      end

      def execute
        package_json = parse_content(PACKAGE_JSON_FILENAME)
        if package_json == nil
          return
        end

        file_version = package_json['version']
        old_version = SemVersion.new(file_version)
        new_version = increment_segment(old_version, @segment)

        replace_infile(PACKAGE_JSON_FILENAME, version_pattern(old_version.to_s), version_pattern(new_version.to_s))
        replace_infile(PACKAGE_LOCK_JSON_FILENAME, version_pattern(old_version.to_s), version_pattern(new_version.to_s))

        puts "v#{file_version.to_s}"

        git = Incr::Service::Git.new('.')
        git.add(PACKAGE_JSON_FILENAME)
        git.add(PACKAGE_LOCK_JSON_FILENAME)
        oid = git.commit(new_version.to_s)
        git.tag("v#{new_version.to_s}", oid)
      end

      private

      def parse_content(filename)
        if !File.exist?(filename)
          STDERR.puts("[Err] '#{filename}' not found.")
          return nil
        end

        JSON.parse(IO.read(filename))
      end

      def increment_segment(version, segment)
        incremented_version = version.clone

        case segment
        when 'major'
          incremented_version.major = version.major + 1
        when 'minor'
          incremented_version.minor = version.minor + 1
        when 'patch'
          incremented_version.patch = version.patch + 1
        end

        incremented_version
      end

      def replace_infile(filename, old_text, new_text)
        old_content = File.read(filename)
        new_content = old_content.gsub(/#{Regexp.escape(old_text)}/, new_text)
        File.open(filename, 'w') { |file| file << new_content }
      end

      def version_pattern(version)
        "\"version\": \"#{version}\""
      end
    end
  end
end
