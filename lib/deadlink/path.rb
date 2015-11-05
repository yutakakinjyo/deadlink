module Deadlink
  class Path
    def initialize(file_path, link, index)
      @file_path = file_path
      @link = link
      @index = index
    end

    def deadlink
      puts @link + ' in ' + @file_path + ' line: ' + @index.to_s if deadlink?
    end

    def deadlink?
      !File.exist?(link_path) && !Dir.exist?(link_path) && !url?
    end

    private

    def url?
      @link =~ /https?:\/\/[\S]+/
    end

    def link_path
      File.expand_path(@link, File.dirname(@file_path))
    end
  end
end
