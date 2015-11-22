module Deadlink
  class MdFile

    attr_reader :path, :headers, :link_paths
    
    def initialize(file_path, repo_root)
      @path = file_path
      init(file_path, repo_root)
    end

    private
    
    def init(file_path, repo_root)
      @headers = []
      @link_paths = []
      File.open(file_path) do |f|
        f.each_with_index do |line,index|
          if line =~ heading_pattern # capture sharp header part
            @headers.push Regexp.last_match[:header]
          elsif line =~ link_pattern # capthure link path part
            @link_paths.push Path.new(file_path, Regexp.last_match[:link], index + 1, repo_root)
          end
        end
      end
    end

    def heading_pattern
      /^\#{1,6} +(?<header>.+)/
    end

    def link_pattern
      /\[[^\]]*\]\((?<link>[^)]+)\)/
    end
    
  end
end
