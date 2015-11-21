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
          if line =~ /^\#{1,6} +(?<header>.+)/ # capture sharp header part
            @headers.push Regexp.last_match[:header]
          end
          line.scan /\[[^\]]*\]\(([^)]+)\)/ do |link|
            @link_paths.push Path.new(file_path, link[0], index + 1, repo_root)
          end
        end
      end
    end
  end
end
