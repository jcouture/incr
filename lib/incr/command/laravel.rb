module Incr
  module Command
    class Laravel
      VERSION_REGEX = /'version' => '(\d*.\d*.\d*)'/
      VERSION_REPLACEMENT_PATTERNS = [
        "'version' => '%s",
      ]

      def initialize(args, global_options)
        @segment = args[0]
        @config_file_filename = File.join('.', global_options[:version_file_dir], 'config', 'app.php')
        @tag_pattern = global_options[:tag_name_pattern]
        @commit = global_options[:commit]
        @tag = global_options[:tag]
        @noop = global_options[:noop]
      end

      def execute
        if !File.exist?(@config_file_filename)
          warn("'#{@config_file_filename}': file not found.")
          return
        end

        file_content = IO.read(@config_file_filename)
        if file_content == nil
          return
        end

        file_version = file_content.match(VERSION_REGEX)[1]
        old_version = SemVersion.new(file_version)
        new_version = Incr::Service::Version.increment_segment(old_version, @segment)
        replace_file_version(old_version, new_version)

        new_tag = @tag_pattern % new_version.to_s

        puts new_tag

        if not @noop
          repository = Incr::Service::Repository.new('.')
          repository.add(@config_file_filename)
          repository.commit(new_tag) if @commit
          repository.tag(new_tag) if @tag
        end
      end

      private

      def replace_file_version(old_version, new_version)
        VERSION_REPLACEMENT_PATTERNS.each do |pattern|
          old_version_pattern = format(pattern, old_version.to_s)
          new_version_pattern = format(pattern, new_version.to_s)

          Incr::Service::FileHelper.replace(@config_file_filename, old_version_pattern, new_version_pattern)
        end
      end
    end
  end
end
