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
          end
          line.scan link_pattern do |link| # capthure links path part
            @link_paths.push Path.new(file_path, link[0], index + 1, repo_root)
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
