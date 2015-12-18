module Deadlink
  class Header

    SHARP_HEADER_PATTERN = /^\#{1,6} +(?<header>.+)/
    UNDER_HEADER_PATTERN = /^[-]+$|^[=]+$/

    def self.header(text)
      header = sharp_header?(text) ? Regexp.last_match[:header] : text
      return self.normalize(header)
    end
    
    def self.header?(text, next_line=nil)
      sharp_header?(text) || under_line_header?(next_line)
    end

    private
    
    def self.normalize(header)
      return header.downcase.rstrip.chomp.gsub(" ", "-")
    end

    def self.sharp_header?(text)
      text =~ SHARP_HEADER_PATTERN
    end

    def self.under_line_header?(next_line)
      next_line =~ UNDER_HEADER_PATTERN && !next_line.nil?
    end

  end
end
