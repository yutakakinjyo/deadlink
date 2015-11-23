module Deadlink
  class Path

    attr_reader :cur_file_path, :link, :index, :anchor

    def initialize(cur_file_path, link, index, repo_root)
      @cur_file_path = cur_file_path
      @link = link
      @index = index
      @repo_root = repo_root
      
      hash = split_link(link)
      @link_file_path = hash[:filepath]
      @anchor = hash[:anchor]

      @abusolute_link_file_path = abusolute_link_file_path
    end

    def deadlink?(files)
      (not_exist? || anchor_invalid?(files)) && not_ignore?
    end
    
    private

    def anchor_invalid?(files)
      return false if @anchor.empty?
      if @link_file_path.empty?
        return header_not_include?(files, @cur_file_path)
      end
      header_not_include?(files, @abusolute_link_file_path)
    end

    def header_not_include?(files, path)
      file = find(files, path)
      unless file.nil?
        return false if file.headers.include?(@anchor)
      end
      true
    end
    
    def find(files, path)
      files.each { |file| return file if file.path == path }
    end

    def exist?
      FileTest.exist?(@abusolute_link_file_path)
    end
    
    def abusolute_link_file_path
      if specify_root?(@link_file_path)
        return File.join(@repo_root, @link_file_path)
      else
        return File.expand_path(@link_file_path, File.dirname(@cur_file_path))
      end
    end

    def split_link(link)
      # split <filenpath>#<anchor>
      hash = link.match(/(?<filepath>[^#]*)#*(?<anchor>.*)/)
    end

    def specify_root?(path)
      path[0] == "/"
    end

    def ignore?
      url?
    end

    def url?
      @link =~ /https?:\/\/[\S]+/
    end

    ## negative wrap 
    
    def not_exist?
      !exist?
    end

    def not_ignore?
      !ignore?
    end
    
  end
end
