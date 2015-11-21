module Deadlink
  class Paths

    attr_reader :deadlinks

    def initialize(files, paths)
      @paths = paths
      @files = files
      @deadlinks = paths.select { |path| path.deadlink? }
    end

    def deadlink_include?
      @deadlinks.any?
    end

    def print_deadlinks(opts)
      @deadlinks.each { |path| Decorator.print_info(path,opts) }
    end

    def count
      @paths.count
    end

  end
end
