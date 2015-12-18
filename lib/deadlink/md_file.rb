module Deadlink
  class MdFile

    attr_reader :path, :headers, :link_paths
    
    def initialize(file_path, repo_root)
      @path = file_path
      @headers = []
      @link_paths = []
      attribute(repo_root)
    end
    
    private
    
    def attribute(repo_root)
      File.open(@path) do |f|
        prev_line = nil
        f.each_with_index do |line,index|
          @headers.push Header.header(line, prev_line) if Header.header?(line)
          prev_line = line

          link(line, index, repo_root) { |path| @link_paths.push path }
        end
      end
    end


    def link(line, index, repo_root)
      line.scan link_pattern do |link| # capthure links path part
        yield Path.new(@path, link[0].rstrip, index + 1, repo_root)
      end
    end
    
    def link_pattern
      /\[[^\]]*\]\((?<link>[^)]+)\)/
    end
    
  end
end
