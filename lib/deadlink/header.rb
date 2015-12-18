module Deadlink
  class Header

    def initialize(name)
      @name = name
    end

    def self.header?(text)
      text =~ sharp_header_pattern
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

    private
    
    def self.sharp_header_pattern
      /^\#{1,6} +(?<header>.+)/
    end

    def under_header_pattern
      /^[-]+$|^[=]+$/
    end


  end
end
