module Deadlink
  class MdFile

    def initialize(file_path)
      @file_path = file_path
    end

    def headers
      headers = []
      File.open(@file_path) do |f|
        f.each do |line|
          if line =~ /^\#{1,6} +(?<header>.+)/ # capture sharp header part
            headers.push Regexp.last_match[:header]
          end
        end
      end
      headers
    end

    def to_s
      @file_path
    end
    
  end
end
