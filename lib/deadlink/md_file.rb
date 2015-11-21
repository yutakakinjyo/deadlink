module Deadlink
  class MdFile

    attr_reader :path, :headers, :link_paths
    
    def initialize(file_path, repo_root)
      @path = file_path
      @headers = _headers(file_path)
      @link_paths = _link_paths(file_path, repo_root)
    end

    private
    
    def _headers(file_path)
      headers = []
      File.open(file_path) do |f|
        f.each do |line|
          if line =~ /^\#{1,6} +(?<header>.+)/ # capture sharp header part
            headers.push Regexp.last_match[:header]
          end
        end
      end
      headers
    end

    def _link_paths(file_path, repo_root)
      paths = []
      File.open(file_path) do |f|
        f.each_with_index do |line, index|
          line.scan /\[[^\]]*\]\(([^)]+)\)/ do |link|
            paths.push Path.new(f.path, link[0], index + 1, repo_root, nil)
          end
        end
      end
    end

  end
end
