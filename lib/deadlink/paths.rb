module Deadlink
  class Paths

    attr_reader :deadlinks

    def initialize(files)
      @files = files
      @paths = []
      @files.each { |file| @paths.concat(file.link_paths) }
      @deadlinks = @paths.select { |path| path.deadlink? }
    end

    def anchor_not_exist?
      @paths.each do |path|
        @files.each do |file|
          if path.anchor_exit?
            return false if file.headers.include?(path.anchor)
          end
        end
      end
      return true
    end
    
    def deadlink_include?
      @deadlinks.any? || anchor_not_exist?
    end

    def print_deadlinks(opts)
      @deadlinks.each { |path| Decorator.print_info(path,opts) }
    end

    def count
      @paths.count
    end

  end
end
