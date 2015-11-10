module Deadlink
  class Paths
    def initialize(paths)
      @paths = paths
      @deadlinks = paths.select { |path| path.deadlink? }
    end

    def deadlink_include?
      @deadlinks.any?
    end

    def deadlinks
      @deadlinks
    end

    def print_deadlinks
      @paths.each { |path| path.deadlink }
    end

    def count
      @paths.count
    end



  end
end
