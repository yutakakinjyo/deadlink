module Deadlink
  class Path
    def initialize(cur_file_path, link, index, repo_root)
      @cur_file_path = cur_file_path
      @link = link
      @index = index
      @repo_root = repo_root
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
      if absolute_path?(path_hash[:filepath])
        return File.join(@repo_root, path_hash[:filepath])
      end

      File.expand_path(path_hash[:filepath], File.dirname(@cur_file_path))
    end

    def path_hash
      # split path ; <filename>#<title>
      path_hash = @link.match(/(?<filepath>[^#]*)#*(?<anchor>.*)/)
    end

    def absolute_path?(path)
      path[0] == "/"
    end

  end
end
