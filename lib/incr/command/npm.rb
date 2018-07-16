require 'json'
require 'sem_version'

module Incr
  module Command
    class Npm

      def initialize(args, global_options)
        @segment = args[0]

        @packageJsonFilename = File.join(".", global_options[:versionFileDirectory], 'package.json')
        @packageJsonLockFilename = File.join(".", global_options[:versionFileDirectory], 'package-lock.json')
        @tagPattern = global_options[:tagNamePattern]
      end

      def execute

        package_json = parse_content(@packageJsonFilename)
        if package_json == nil
          return
        end

        file_version = package_json['version']
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)

        Incr::Service::FileHelper.replace_once(@packageJsonFilename, version_pattern(old_version.to_s), version_pattern(new_version.to_s))
        Incr::Service::FileHelper.replace_once(@packageJsonLockFilename, version_pattern(old_version.to_s), version_pattern(new_version.to_s))

        newTag = @tagPattern % new_version.to_s

        puts newTag

        repository = Incr::Service::Repository.new('.')
        repository.add(@packageJsonFilename)
        repository.add(@packageJsonLockFilename)
        repository.commit(newTag)

        repository.tag(newTag)
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
