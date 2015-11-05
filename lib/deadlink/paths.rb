module Deadlink
  class Paths
    def initialize(paths)
      @paths = paths
    end

    def deadlink_include?
      @paths.each do |path|
        return true if path.deadlink?
      end
      false
    end

    def print_deadlinks
      @paths.each { |path| path.deadlink }
      
    end

    def count
      @paths.count
    end

    def [](i)
      @paths[i]
    end

  end
end
