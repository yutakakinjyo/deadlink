module Deadlink
  class Decorator
    def self.print_info(path)
      puts path.link + ' in ' + path.cur_file_path + ' line: ' + path.index.to_s
    end
  end
end
