module Deadlink
  class Header

    SHARP_HEADER_PATTERN = /^\#{1,6} +(?<header>.+)/
    UNDER_HEADER_PATTERN = /^[-]+$|^[=]+$/

    def self.header(text, prev_line=nil)
      header = text =~ SHARP_HEADER_PATTERN ? Regexp.last_match[:header] : prev_line
      return self.normalize(header)
    end
    
    def self.header?(text)
      sharp_header?(text) || under_line_header?(text)
    end

    private
    
    def self.normalize(header)
      return header.downcase.rstrip.chomp.gsub(" ", "-")
    end

    def self.sharp_header?(text)
      text =~ SHARP_HEADER_PATTERN
    end

    def self.under_line_header?(text)
      text =~ UNDER_HEADER_PATTERN
    end

  end
end
