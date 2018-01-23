require 'json'
require 'sem_version'

module Incr
  module Command
    class Ruby
      VERSION_FILENAME = 'version.rb'.freeze

      def initialize(args)
        @segment = args[0]
      end

      def execute
        file_content = parse_content(VERSION_FILENAME)
        if file_content == nil
          return
        end

        file_version = file_content.match(/VERSION\W=\W["'](\d*.\d*.\d*)/)[1]
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)
        Incr::Service::FileHelper.replace(VERSION_FILENAME, old_version.to_s, new_version.to_s)

        git = Incr::Service::Git.new('.')
        git.add(VERSION_FILENAME)
        oid = git.commit(new_version.to_s)
        git.tag("v#{new_version.to_s}", oid)
      end

      private

      def parse_content(filename)
        if !File.exist?(filename)
          STDERR.puts("[Err] '#{filename}' not found.")
          return nil
        end

        IO.read(filename)
      end
    end
  end
end
