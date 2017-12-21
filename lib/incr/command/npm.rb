require 'json'

module Incr
  module Command
    class Npm
      def initialize(args)
        @segment = args[0]
      end

      def execute()
        puts "Updating #{@segment}..."
      end
    end
  end
end
