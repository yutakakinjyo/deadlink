module Deadlink
  class Path
    def initialize(file_path, link, index)
      @file_path = file_path
      @link = link[0]
      @index = index
    end

    def deadlink
      puts @link + ' in ' + @file_path + ' line: ' + @index.to_s if deadlink?
    end

    def exist?
      link_path = get_path(@link, @file_path)
      File.exist?(link_path) || Dir.exist?(link_path)
    end

    def deadlink?
      link_path = get_path(@link, @file_path)
      !File.exist?(link_path) && !Dir.exist?(link_path)
    end

    def get_path(link, file_path)
      File.expand_path(link, File.dirname(file_path))
    end
  end
end
