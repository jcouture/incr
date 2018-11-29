require 'json'
require 'sem_version'

module Incr
  module Command
    class Npm

      def initialize(args, global_options)
        @segment = args[0]

        @package_json_filename = File.join('.', global_options[:versionFileDirectory], 'package.json')
        @package_json_lock_filename = File.join('.', global_options[:versionFileDirectory], 'package-lock.json')
        @tag_pattern = global_options[:tagNamePattern]
        @commit = global_options[:commit]
        @tag = global_options[:tag]
      end

      def execute
        package_json = parse_content(@package_json_filename)
        if package_json == nil
          return
        end

        file_version = package_json['version']
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)

        Incr::Service::FileHelper.replace_once(@package_json_filename, version_pattern(old_version.to_s), version_pattern(new_version.to_s))
        Incr::Service::FileHelper.replace_once(@package_json_lock_filename, version_pattern(old_version.to_s), version_pattern(new_version.to_s))

        new_tag = @tag_pattern % new_version.to_s

        puts new_tag

        repository = Incr::Service::Repository.new('.')
        repository.add(@package_json_filename)
        repository.add(@package_json_lock_filename)
        repository.commit(new_tag) if @commit
        repository.tag(new_tag) if @tag
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
