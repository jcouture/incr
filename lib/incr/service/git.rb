require 'rugged'

module Incr
  module Service
    class Git
      def initialize(path)
        @repository = Rugged::Repository.new(path)
        @index = @repository.index
        @author = @repository.head.target.author
      end

      def add(filename)
        @index.add(filename)
        @index.write
      end

      def commit(message)
        options = {}
        options[:tree] = @index.write_tree(@repository)

        author = @author.clone
        author[:time] = Time.now

        options[:author] = author
        options[:committer] = author
        options[:message] ||= message
        options[:parents] = @repository.empty? ? [] : [ @repository.head.target ].compact
        options[:update_ref] = 'HEAD'

        Rugged::Commit.create(@repository, options)
      end

      def tag(name, target)
        author = @author.clone
        author[:time] = Time.now

        # annotation = {
        #   tagger: author,
        #   message: 'a message?'
        # }
        # @repository.tags.create(name, target, annotation)
        @repository.tags.create(name, target)
      end
    end
  end
end
