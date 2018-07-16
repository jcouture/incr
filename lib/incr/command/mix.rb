module Incr
  module Command
    class Mix
      def initialize(args, global_options)
        @segment = args[0]
        @mixFileFilename = File.join(".", global_options[:versionFileDirectory], 'mix.exs')
        @tagPattern = global_options[:tagNamePattern]
      end

      def execute
        file_content = parse_content(@mixFileFilename)
        if file_content == nil
          return
        end

        file_version = file_content.match(/version:\W*\"(\d*.\d*.\d*)",/)[1]
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)
        Incr::Service::FileHelper.replace_once(@mixFileFilename, version_pattern(old_version.to_s), version_pattern(new_version.to_s))

        newTag = @tagPattern % new_version.to_s

        puts newTag

        repository = Incr::Service::Repository.new('.')
        repository.add(@mixFileFilename)
        repository.commit(newTag)
        repository.tag(newTag)
      end

      private

      def parse_content(filename)
        if !File.exist?(filename)
          STDERR.puts("[Err] '#{filename}' not found.")
          return nil
        end

        IO.read(filename)
      end

      def version_pattern(version)
        "version: \"#{version}\""
      end
    end
  end
end
