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
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)

        Incr::Service::FileHelper.replace_once(PACKAGE_JSON_FILENAME, version_pattern(old_version.to_s), version_pattern(new_version.to_s))
        Incr::Service::FileHelper.replace_once(PACKAGE_LOCK_JSON_FILENAME, version_pattern(old_version.to_s), version_pattern(new_version.to_s))

        puts "v#{new_version.to_s}"

        repository = Incr::Service::Repository.new('.')
        repository.add(PACKAGE_JSON_FILENAME)
        repository.add(PACKAGE_LOCK_JSON_FILENAME)
        repository.commit(new_version.to_s)
        repository.tag("v#{new_version.to_s}")
      end

      private

      def parse_content(filename)
        if !File.exist?(filename)
          STDERR.puts("[Err] '#{filename}' not found.")
          return nil
        end

        JSON.parse(IO.read(filename))
      end

      def version_pattern(version)
        "\"version\": \"#{version}\""
      end
    end
  end
end
