module Incr
  module Service
    class FileHelper
      def self.replace(filename, old_text, new_text)
        old_content = File.read(filename)
        new_content = old_content.gsub(/#{Regexp.escape(old_text)}/, new_text)
        File.open(filename, 'w') { |file| file << new_content }
      end
    end
  end
end
