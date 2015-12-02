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
          sharp_header(line) { |header| @headers.push header }
          link(line, index, repo_root) { |path| @link_paths.push path }
          under_line_header(line, prev_line) { |header| @headers.push header }
          prev_line = line
        end
      end
    end

    def sharp_header(line)
      if line =~ heading_pattern # capture sharp header part
        header = Regexp.last_match[:header].downcase.rstrip.gsub(/\s+/," ")
        yield header.gsub(" ", "-")
      end
    end
    
    def under_line_header(line, prev_line)
      if line =~ /^[-]+$|^[=]+$/
        unless prev_line.nil?
          yield prev_line.chomp
        end
      end
    end

    def link(line, index, repo_root)
      line.scan link_pattern do |link| # capthure links path part
        yield Path.new(@path, link[0].rstrip, index + 1, repo_root)
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
