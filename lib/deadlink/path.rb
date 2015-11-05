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
      !exist? && ignore 
    end

    private
    
    def exist?
      File.exist?(link_path) || Dir.exist?(link_path)
    end

    def ignore
      !url?
    end

    def url?
      @link =~ /https?:\/\/[\S]+/
    end

    def link_path
      # split path ; <filename>#<title>
      r = @link.match(/(?<filelink>[^#]*)#*(?<anchor>.*)/)
      File.expand_path(r[:filelink], File.dirname(@file_path))
    end

  end
end
