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
          sharp_header(line) { |header| @headers.push normalize header }
          under_line_header(line, prev_line) { |header| @headers.push normalize header }; prev_line = line
          link(line, index, repo_root) { |path| @link_paths.push path }
        end
      end
    end

    def sharp_header(line)
      if line =~ sharp_header_pattern # capture sharp header part
        header = Regexp.last_match[:header]
        yield header
      end
    end
    
    def under_line_header(line, prev_line)
      if line =~ under_header_pattern && !prev_line.nil?
        yield prev_line # prev_line is header.
      end
    end

    def normalize(header)
      return header.downcase.rstrip.chomp.gsub(" ", "-")
    end

    def link(line, index, repo_root)
      line.scan link_pattern do |link| # capthure links path part
        yield Path.new(@path, link[0].rstrip, index + 1, repo_root)
      end
    end

    def sharp_header_pattern
      /^\#{1,6} +(?<header>.+)/
    end

    def under_header_pattern
      /^[-]+$|^[=]+$/
    end
    
    def link_pattern
      /\[[^\]]*\]\((?<link>[^)]+)\)/
    end
    
  end
end
