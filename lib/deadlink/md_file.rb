module Deadlink
  class MdFile

    attr_reader :path, :headers, :link_paths
    
    def initialize(file_path, repo_root)
      @path = file_path
      @headers = []
      @link_paths = []
      init(repo_root)
    end
    
    private
    
    def init(repo_root)
      File.open(@path) do |f|
        prev_line = nil
        f.each_with_index do |line,index|
          attribute(line, index, repo_root)
          if line =~ /^[-]+$|^[=]+$/
            unless prev_line.nil?
              if prev_line =~ /^[-]+$|^[=]+$/
              end
            end
          end
          prev_line = line
        end
      end
    end

    def attribute(line, index, repo_root)
      if line =~ heading_pattern # capture sharp header part
        header = Regexp.last_match[:header].downcase.rstrip.gsub(/\s+/," ")
        @headers.push header.gsub(" ", "-")
      end
      line.scan link_pattern do |link| # capthure links path part
        @link_paths.push Path.new(@path, link[0].rstrip, index + 1, repo_root)
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
