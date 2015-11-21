module Deadlink
  class MdFile

    attr_reader :file_path, :headers, :paths
    
    def initialize(file_path, repo_root)
      @file_path = file_path
      @headers = scan_headers(file_path)
      @paths = scan_paths(file_path, repo_root)
    end

    private
    
    def scan_headers(file_path)
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

    def scan_paths(file_path, repo_root)
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
