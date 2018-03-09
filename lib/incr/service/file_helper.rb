module Incr
  module Service
    class FileHelper
      def self.replace_once(filename, old_text, new_text)
        old_content = File.read(filename)
        new_content = old_content.sub(/#{Regexp.escape(old_text)}/, new_text)
        File.open(filename, 'w') { |file| file << new_content }
      end
    end
  end
end
