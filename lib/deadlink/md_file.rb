module Deadlink
  class MdFile

    attr_reader :path, :headers, :link_paths
    
    def initialize(file_path)
      @path = file_path
      @headers = _headers(file_path)
    end

    private
    
    def _headers(file_path)
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

  end
end
