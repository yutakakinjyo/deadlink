module Deadlink
  class Path
    def initialize(file_path, link, index, repo_root)
      @file_path = file_path
      @link = link
      @index = index
      @repo_root = repo_root
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
      cap = @link.match(/(?<filelink>[^#]*)#*(?<anchor>.*)/)
      if cap[:filelink][0] == "/"
        return File.join(@repo_root, cap[:filelink])
      end

      File.expand_path(cap[:filelink], File.dirname(@file_path))
    end


  end
end
