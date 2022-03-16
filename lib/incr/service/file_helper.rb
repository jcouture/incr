module Incr
  module Service
    class FileHelper
      def self.replace_string_once(filename, old_text, new_text)
        replace_regexp_once(filename, /#{Regexp.escape(old_text)}/, new_text)
      end

      def self.replace_regexp_once(filename, pattern, replacement_text)
        old_content = File.read(filename)
        new_content = old_content.sub(pattern, replacement_text)
        File.open(filename, 'w') { |file| file << new_content }
      end
    end
  end
end
