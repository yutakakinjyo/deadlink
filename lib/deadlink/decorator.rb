module Deadlink
  class Decorator
    def self.print_info(path,opts)
      if opts['p']
        puts '+' + path.index.to_s + " " + path.cur_file_path
      else
        puts path.link + ' in ' + path.cur_file_path + ' line: ' + path.index.to_s
      end
    end
  end
end
