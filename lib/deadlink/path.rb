module Deadlink
  class Path
    def initialize(cur_file_path, link, index, repo_root)
      @cur_file_path = cur_file_path
      @link = link
      @index = index
      @repo_root = repo_root
      
      hash = split_link(link)
      @link_file_path = hash[:filepath]
      @anchor = hash[:anchor]
    end

    def deadlink
      puts @link + ' in ' + @cur_file_path + ' line: ' + @index.to_s if deadlink?
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
      if absolute_path?(@link_file_path)
        return File.join(@repo_root, @link_file_path)
      end

      File.expand_path(@link_file_path, File.dirname(@cur_file_path))
    end

    def split_link(link)
      # split path ; <filename>#<title>
      hash = link.match(/(?<filepath>[^#]*)#*(?<anchor>.*)/)
    end

    def absolute_path?(path)
      path[0] == "/"
    end

  end
end
