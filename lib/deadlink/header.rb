module Deadlink
  class Header

    SHARP_HEADER_PATTERN = /^\#{1,6} +(?<header>.+)/
    UNDER_HEADER_PATTERN = /^[-]+$|^[=]+$/

    def self.header(text)
      header = sharp_header?(text) ? Regexp.last_match[:header] : text
      return self.normalize(header)
    end
    
    def self.header?(text, next_line=nil)
      return true if sharp_header?(text)
      next_line =~ UNDER_HEADER_PATTERN && !next_line.nil?
    end

    private
    
    def self.normalize(header)
      return header.downcase.rstrip.chomp.gsub(" ", "-")
    end

    def self.sharp_header?(text)
      text =~ SHARP_HEADER_PATTERN
    end

  end
end
