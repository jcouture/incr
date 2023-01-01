module Incr
  module Service
    class FileHelper
      def self.replace(filename, pattern, replacement_text)
        old_content = File.read(filename)
        new_content = old_content.sub(pattern, replacement_text)
        File.open(filename, 'w') { |file| file << new_content }
      end
    end
  end
end
