module Deadlink
  class Path

    attr_reader :link, :cur_file_path, :index

    def initialize(cur_file_path, link, index, repo_root)
      @link = link
      @cur_file_path = cur_file_path
      @index = index

      @repo_root = repo_root
      
      hash = split_link(link)
      @link_file_path = hash[:filepath]
      @anchor = hash[:anchor]
    end

    def deadlink?
      !FileTest.exist?(link_path) && ignore 
    end

    private

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
      # split <filenpath>#<anchor>
      hash = link.match(/(?<filepath>[^#]*)#*(?<anchor>.*)/)
    end

    def absolute_path?(path)
      path[0] == "/"
    end

  end
end
