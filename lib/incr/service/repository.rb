require 'git'

module Incr
  module Service
    class Repository
      def initialize(path)
        @git = Git.init(path)
      end

      def add(filename)
        @git.add(filename)
      end

      def commit(message)
        @git.commit(message)
      end

      def tag(name)
        @git.add_tag(name)
      end
    end
  end
end
