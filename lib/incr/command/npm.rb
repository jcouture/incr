require 'json'
require 'sem_version'

module Incr
  module Command
    class Npm
      # pattern for any semver version, including pre-release label (ie. 1.0.0-alpha)
      VERSION_PATTERN = "[\\w\\.\\-]*"

      # pattern preceding the version in package.json and package-lock.json (v1 and v2)
      LOOKBEHIND_PATTERNS = [
        "\\A{[^{}]*\"version\": \"\\K",
        "\"\": {[^{}]*\"version\": \"\\K"
      ]

      def initialize(args, global_options)
        @segment = args[0]

        @package_json_filename = File.join('.', global_options[:version_file_dir], 'package.json')
        @package_json_lock_filename = File.join('.', global_options[:version_file_dir], 'package-lock.json')
        @tag_pattern = global_options[:tag_name_pattern]
        @commit = global_options[:commit]
        @tag = global_options[:tag]
        @noop = global_options[:noop]
      end

      def execute
        if !File.exist?(@package_json_filename)
          warn("'#{@package_json_filename}': file not found.")
          return
        end

        if !File.exist?(@package_json_lock_filename)
          warn("'#{@package_json_lock_filename}': file not found.")
          return
        end

        package_json = JSON.parse(IO.read(@package_json_filename))
        if package_json == nil
          return
        end

        file_version = package_json['version']
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)

        replace_file_version(@package_json_filename, new_version.to_s)
        replace_file_version(@package_json_lock_filename, new_version.to_s)

        new_tag = @tag_pattern % new_version.to_s

        puts new_tag

        if not @noop
          repository = Incr::Service::Repository.new('.')
          repository.add(@package_json_filename)
          repository.add(@package_json_lock_filename)
          repository.commit(new_tag) if @commit
          repository.tag(new_tag) if @tag
        end
      end

      private

      def replace_file_version(filename, new_version)
        LOOKBEHIND_PATTERNS.each do |lookbehind_pattern|
          pattern = /#{lookbehind_pattern}#{VERSION_PATTERN}/
          Incr::Service::FileHelper.replace_regexp_once(filename, pattern, new_version)
        end
      end
    end
  end
end
