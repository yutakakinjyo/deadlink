# coding: utf-8
module Deadlink
  class Path

    attr_reader :cur_file_path, :link, :index, :anchor

    def initialize(cur_file_path, link, index, repo_root)
      @cur_file_path = cur_file_path
      @link = link
      @index = index
      @repo_root = repo_root
      
      hash = split_link(link)
      @anchor = hash[:anchor]
      @link_file_path = hash[:filepath]


      @abs_link_file_path = abs_link_file_path
    end

    def deadlink?(files)
      (not_exist? || anchor_invalid?(files)) && not_ignore?
    end
    
    private

    def anchor_invalid?(files)
      return false if @anchor.empty?

      # e.g [](#anchor)
      path =  only_anchor? ? @cur_file_path : @abs_link_file_path
      file = files.find_by(path)
      return !file.headers.include?(@anchor)
    end

    def only_anchor?
      @link_file_path.empty? && !@anchor.empty? 
    end
    
    def exist?
      FileTest.exist?(@abs_link_file_path)
    end
    
    def abs_link_file_path
      
      if specify_root?(@link_file_path)
        return File.join(@repo_root, @link_file_path)
      else
        return File.expand_path(@link_file_path, File.dirname(@cur_file_path))
      end
    end

    def split_link(link)
      # split <filenpath>#<anchor>
      link.match(/(?<filepath>[^#?]*)#*(?<anchor>[[^?][.]]*)/)
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
